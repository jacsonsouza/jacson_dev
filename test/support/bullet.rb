module BulletHelper
  def before_setup
    Bullet.start_request
    super if defined?(super)
  end

  def after_teardown
    super if defined?(super)

    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end

  def setup
    Bullet.unused_eager_loading_enable = false
  end

  def teardown
    Bullet.unused_eager_loading_enable = true
  end
end