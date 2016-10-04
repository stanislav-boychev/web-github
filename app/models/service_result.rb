class ServiceResult
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def success?
    true
  end

  def fail?
    !success?
  end
end
