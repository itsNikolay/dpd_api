module RspecHelper
  def enable_debug!
    DpdApi.configure { |c| c.debug = true }
  end
end
