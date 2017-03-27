//
//  ViewController.m
//  iPhoneImages
//
//  Created by Pierre Binon on 2017-03-27.
//  Copyright © 2017 Pierre Binon. All rights reserved.
//

//Learning Outcomes
//-----------------
//Understand how to use NSURLSession to download files.
//Understand how to download on a background thread and update UI on the main threa



#import "ViewController.h"




@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iPhoneImageView;
@property (nonatomic) NSArray *iPhoneImages;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.iPhoneImages = @[ @"http://imgur.com/y9MIaCS.png", @"http://imgur.com/bktnImE.png", @"http://imgur.com/zdwdenZ.png", @"http://imgur.com/CoQ8aNl.png", @"http://imgur.com/2vQtZBb.png"];
    
    //The following line replaced with the content of the button method
    //NSURL *url = [NSURL URLWithString: @"http://imgur.com/y9MIaCS.png"]; //1
    

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; //2
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration]; //3
    
    
    //The completion handler takes 3 parameters:
    //location: The location of a file we just downloaded on the device.
    //response: Response metadata such as HTTP headers and status codes.
    //error: An NSError that indicates why the request failed, or nil when the request is successful.
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL: [self returnURL:<#(NSString *)#>] completionHandler: ^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { //6
            
            //Handle the error
            NSLog (@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL: location];
        UIImage *image = [UIImage imageWithData: data]; //7
        
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            //This will run on the main queue
            self.iPhoneImageView.image = image; //8
        }];
    }]; //4
    
    [downloadTask resume]; //5
    
    
}

- (IBAction)randomiPhoneButton:(UIButton *)sender {
    
    int random = arc4random_uniform(self.iPhoneImages.count);
    NSString *tempString = self.iPhoneImages[random];
    NSLog(@"imgur url = %@", tempString);
    [self returnURL: tempString];
}


- (NSURL *) returnURL: (NSString *) string {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@", string]];
    return url;
}















- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


//=====================================================================================================================
//    1. Create a new NSURL object from the iPhone image url string.
//    2. An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object. The default system values are good for now, so we'll just grab the default configuration.
//    3. Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
//    4. We create a task that will actually download the image from the server. The session creates and configures the task and the task makes the request. Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app is not running. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
//    5. A task is created in a suspended state, so we need to resume it. We can also You can also suspend, resume and cancel tasks whenever we want.
//    6. If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
//    7. The download task downloads the file to the iPhone then lets us know the location of the download using a local URL. In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object, then create a UIImage from that data.
//    8.The only thing left to do is display the image on the screen. This is almost as simple as self.iPhoneImageView.image = image; however the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread.
//======================================================================================================================
//How to open your Info.plist as Source Code
//------------------------------------------
//    1) show the version editor. The source of the previous and current versions are shown side by side. where to select version editor (double arrow icon)
//
//    2) use the file browser... (there should be a way to automate this with Xcode behaviors)
//
//    Hold the Control key while selecting the file in the file browser.
//        Select 'Open As..'
//        Select 'Source Code'
//        Screen shot of menu selections
//======================================================================================================================
