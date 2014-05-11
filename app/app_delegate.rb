class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # alert = UIAlertView.new
    # alert.message = "hello world"
    # alert.show()
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    # add new
    @window.rootViewController = ClockController.alloc.initWithNibName(nil, bundle: nil)
    true
  end
end
