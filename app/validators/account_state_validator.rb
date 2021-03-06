class AccountStateValidator < ActiveModel::EachValidator

  # ready|accepted|cancelled|arrived_at_pickup|arrived_at_dropoff|billed
  def validate_each(record, attribute, value)
    begin
      result = Courier.valid_account_state? value
    rescue
    end
    record.errors[attribute] << "is not a valid account state, was #{value.inspect} #{value.to_sym}" unless result
  end    
end

