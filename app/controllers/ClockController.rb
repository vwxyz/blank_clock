class ClockController  < UIViewController
  # attr_accessor :initLayout
  # attr_accessor :switchAutoLock
  # attr_accessor :textTile
  # attr_accessor :startAnimation
  def viewDidLoad
    super
    # self.view.backgroundColor = UIColor.redColor   
    self.initLayout
    self.switchAutoLock
    p "end:viewDidLoad"
  end

  def switchAutoLock
    p "switchAutoLock"
    defaults = NSUserDefaults.standardUserDefaults
    lockSwitch = defaults.boolForKey("disabled_automatic_locking")
    application = UIApplication.sharedApplication
    if (lockSwitch == true) then
        application.idleTimerDisabled = false
    else
        application.idleTimerDisabled = true
    end
  end

  def applicationWillTerminate(application)
    UIApplication.sharedApplication.idleTimerDisabled = false
  end

  def didReceiveMemoryWarning
    super
  end
  # インスタンス変数1
  # bundle = NSBundle.new # #getTextDataのみ
  # path   = NSString.new # #getTextData,#loadCoordsFromPlist, #initLayout
  # filedata = NSString.new　#getTextDataのみ
  # arr = NSMutableArray.new #不使用
  # rectArr = NSMutableArray.new # #initLayout, 

  # インスタンス変数1
  # rootLayer = CALayer.new # #initLayout
  # transform = CATransform3D.new

  # # 日付取得メソッド

  # def getDate
  #   # 日付取得
  #   calendar = NSCalendar.currentCalendar
  #   date     = NSDate.date
  #   comps    = NSDateComponents.new

  #   # 時分秒をとりだす。compの値変更
  #   comps = calendar.components((NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit), fromDate:date)
  #   NSInteger hour   = comps.hour
  #   NSInteger minute = comps.minute
  #   formattedTime    = NSString.stringWithFormat("%02d%02d", hour, minute)
  #   NSLog("formattedTime->%@", formattedTime)
  #   return formattedTime
  # end
  # # 背景用テキスト読込
  # # filedataに文字列として保存
  # def getTextData

  #   bundle = NSBundle.mainBundle
  #   path = bundle.pathForResource("background", ofType:"txt")
  #   filedata = NSString.stringWithContentsOfFile(path, encoding:NSUTF8StringEncoding, error:nil)
  #   # テキストデータを１文字ずつ分割し、配列arrCharへ保存
  #   arrChar = NSMutableArray.alloc.init
  #   # NSLog("%d",filedata.length)
  #   i = 0
  #   while i < filedata.length do
  #       item = filedata.substringWithRange(NSMakeRange(i, 1))
  #       arrChar.addObject(item)
  #       i = i+1
  #   end
  #   return arrChar
  # end

  # 文字矩形のひな形を返す
  def textTile(value,size:size,originWidth:originWidth,originHeight:originHeight)
    # インスタンス
    tile = CATextLayer.layer
    # 基準サイズ
    # テキスト
    tile.string   = value
    tile.font     = "HiraMinProN-W6"
    tile.fontSize = size
    # 矩形サイズ。
    tile.frame = CGRectMake(originWidth, originHeight, size, size)
    # 矩形角丸
        # tile.cornerRadius = 6.;
    # 色空間
    space = CGColorSpaceCreateDeviceRGB()
    # originally: CGFloat values2[4] = {0.1, 0.1, 0.1, .5f};
    values2 = Pointer.new(:float,4)
    values2[0] = 0.1 
    values2[1] = 0.1
    values2[2] = 0.1
    values2[3] = 0.5
    color2     = CGColorCreate(space, values2)
    tile.backgroundColor       = color2
    # originally: CGFloat values3[4] = {1,1,1,1};
    values3    = Pointer.new(:float,4)
    values3[0] = 1.0 
    values3[1] = 1.0
    values3[2] = 1.0
    values3[3] = 1.0
    color3     = CGColorCreate(space, values3)
    tile.foregroundColor = color3
    # 色情報削除
    CGColorRelease(color2);
    CGColorRelease(color3);
    return tile
  end
  # テキストを画面に敷き詰める
  # 最後に、アニメーションのトリガーを引く
  def initLayout
  #   # txtデータ読込
    path = NSBundle.mainBundle.pathForResource("background", ofType:"plist")
    arr = NSMutableArray.arrayWithContentsOfFile(path)
    # p arr
    # 色空間をrgbに
    space = CGColorSpaceCreateDeviceRGB()
    p space
    # ベースのレイヤーつくる
    # CALayerつくる
    rootLayer = CALayer.layer
    rootLayer.frame = CGRectMake(0, 0, 320, 548) #[[0, 0], [320, 548]]

    # CGFloat型の配列

    values = Pointer.new(:float,4)
    values[0] = 0
    values[1] = 0.3 #0
    values[2] = 0
    values[3] = 1.0
    p values[3]
    color = CGColorCreate(space, values)
    rootLayer.backgroundColor = color
    # rootLayer.backgroundColor = UIColor.darkGrayColor.CGColor # .redColor.CGColor
    # 色をクリア
    CGColorRelease(color)
    #
    self.view.layer.addSublayer(rootLayer)
    p "initLayout/after values"
    # p "arr[100..120::#{arr[100..120]}"
    # サブレイヤ
    number = 8
    distance = 0
    xPoint = 0
    yPoint = 0
    # rectArr初期化
    rectArr = NSMutableArray.alloc.init
    # arrLength =500
    arrLength = arr.count
    p "arr.count:#{arr.count}"
    # 上限＝2800文字。それ以降はカット
    if arrLength > 2800 then
        arrLength = 2800
    end
    i = 0
    while i < arrLength do
        tile = self.textTile(arr[i],size:number,originWidth:xPoint,originHeight:yPoint)
        xPoint = xPoint+number+distance
        if xPoint > 312 then
            yPoint = yPoint+number+distance
            xPoint = 0
        end
        rectArr.addObject(tile)
        rootLayer.addSublayer(tile)
        i = i+1
        # p "i = #{i}"
    end
    # 矩形の移動用の座標
    self.startAnimation(rectArr)
  end

  # plistを読込んで辞書インスタンス返す
  def loadCoordsFromPlist(hhmm)
  #   result = NSDictionary.alloc.init
  #   path = NSBundle.mainBundle.pathForResource(hhmm, ofType:"plist")
  #   result = NSDictionary.dictionaryWithContentsOfFile(path)
  #   return result    
  end

  # アニメーションのタイミングを指定し、
  # アニメーション実装を渡し、
  # アニメーションに渡す配列を指定、
  def startAnimation(arr)
    p "startAnimation"
  #   NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector:"moveTileWithSlide:", userInfo:arr,repeats:true)
  end
  # アニメーション詳細
  # 動かす矩形リストはNSTimerから受け取る
  # 矩形リストの終点座標は、
  def moveTileWithSlide(timer)
  #   # 矩形の配列ロード
  #   tiles = timer.userInfo
  #   # デジタル時刻に対応した
  #   # 矩形座標リスト読込
  #   hhmm = self.getDate
  #   NSLog(hhmm)
  #   positionRectArr =self.loadCoordsFromPlist(hhmm)
  #   # デジタル時刻取得
  #   dataPosition = positionRectArr[hhmm]
  #   # 配列の要素数
  #   numberOfTiles = tiles.count
  #   # それぞれの矩形へアニメーション追加
  #   i = 0
  #   while i < numberOfTiles do
  #     CATextLayer *item = tiles[i];
  #     CAKeyframeAnimation *move = CAKeyframeAnimation.animationWithKeyPath("position")
  #     move.calculationMode = kCAAnimationCubic;
  #     # 始点〜終点の所要時間
  #     move.duration =10
  #     move.timingFunction = CAMediaTimingFunction.functionWithName(kCAMediaTimingFunctionEaseInEaseOut)
  #     # 終点、経路の算出
  #     newX = dataPosition[i][0].floatValue
  #     newY = dataPosition[i][1].floatValue

  #     # 終点
  #     newValue = CGPointMake(newX, newY);
  #     # 改行数(+/-)
  #     numberOfLine = (newValue.y - item.position.y)/8
  #     arrValues   =NSMutableArray.alloc.init
  #     arrKeytimes =NSMutableArray.alloc.init
  #     # 始点追加
  #     arrValues.addObject(NSValue.valueWithCGPoint(item.position))
  #     arrKeytimes.addObject(0)
  #     # 下移動
  #     if (newValue.y-item.position.y)>0 then
  #       i=1
  #       while i >= numberOfLine do
  #         arrValues.addObject(NSValue.valueWithCGPoint(CGPointMake(316, item.position.y+(i-1)*8)))
  #         arrValues.addObject(NSValue.valueWithCGPoint(CGPointMake(4, item.position.y+i*8)))
  #         i = i+ 1
  #       end
  #     end
  #     if numberOfLine>0 then
  #       denom = numberOfLine+1
  #       i = 1
  #       while i < donom do
  #         num = i/denom
  #         arrKeytimes.addObject(@num)
  #         arrKeytimes.addObject(@num)
  #       end
  #     end
  #     # 終点追加
  #     arrValues.addObject(NSValue.valueWithCGPoint(newValue))
  #     # keytime終点
  #     arrKeytimes.addObject(1)
  #     move.values   = NSArray.arrayWithArray(arrValues)
  #     move.keyTimes = NSArray.arrayWithArray(arrKeytimes)
  #     item.addAnimation(move, forKey:"moveAnimation")
  #     # 移動したら座標を保存
  #     item.position = newValue
  #     i = i + 1
  #   end
  end
end