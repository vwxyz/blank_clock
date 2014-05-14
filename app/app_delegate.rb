class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    p "hello"
    # self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # self.viewController = ViewController.alloc.initWithNibName("ClockController", bundle:nil)
    # self.window.rootViewController = self.viewController
    # self.window.makeKeyAndVisible

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    p "world"
    # add new
    @window.rootViewController = ClockController.alloc.initWithNibName(nil, bundle: nil)
    true
  end
end
