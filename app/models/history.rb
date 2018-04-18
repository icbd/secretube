class History < ApplicationRecord
  belongs_to :user
  belongs_to :container

  def initialize(container, info = nil)
    super()

    unless container.instance_of?(Container)
      raise Exceptions::ParamsError, __method__.to_s
    end

    write_attribute(:container_id, container.id)
    write_attribute(:user_id, container.user_id)
    write_attribute(:status, container.status_before_type_cast) # get int of enum item, rails5 only
    write_attribute(:info, info)
    write_attribute(:timestamp, Time.now.to_i) # timestamp without timezone

    self
  end

  def save(clearing = true)
    super()

    if clearing
      self.clearing!
    end
  end

  # just calc fee for clearing
  def clearing
    if status == Container.statuses[:stopped]
      last_history = History.where("id<? AND status=?", id, Container.statuses[:running]).order(:id).last

      if last_history.nil?
        raise StandardError, "clearing not found last record"
      end

      fee = timestamp - last_history.timestamp
    else
      fee = 0
    end

    fee
  end


  # calc fee and update user coin
  def clearing!
    fee = 0
    ActiveRecord::Base.transaction do
      fee = clearing

      if fee == 0
        # do nothing
      elsif fee > 0
        User.update_counters(user_id, coin: -1 * fee)
      else
        raise StandardError, "fee must >= 0"
      end
    end

    logger.info "fee:#{fee}"
    fee
  end
end
