//
//  ScannerViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/13/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "ScannerViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ScannerViewController ()
    @property (nonatomic, strong) AVCaptureSession *captureSession;
    @property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
    @property (nonatomic, strong) AVAudioPlayer *audioPlayer;

-(void)stopScanning;
-(void)loadBeepSound;
@end

@implementation ScannerViewController {
    NSArray *supportedMetaTypes;
    NSUserDefaults *defaults;
}
@synthesize captureSession, videoPreviewLayer, viewPreview, audioPlayer, btnFlash, btnCancel, imgStatusIcon, lblStatusTitle, lblStatusText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    supportedMetaTypes = @[
                   AVMetadataObjectTypeQRCode,
                   AVMetadataObjectTypeEAN8Code,
                   AVMetadataObjectTypeEAN13Code,
                   AVMetadataObjectTypeCode93Code,
                   AVMetadataObjectTypeCode39Code,
                   AVMetadataObjectTypeCode39Mod43Code,
                   AVMetadataObjectTypeCode128Code,
                ];
    
    btnCancel.layer.cornerRadius = 4;
    [self loadBeepSound];
    [self startScanning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if(metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if([supportedMetaTypes containsObject:[metadataObject type]]) {
            NSLog(@"READ VALUE: %@", [metadataObject stringValue]);
            [self performSelectorOnMainThread:@selector(stopScanning) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(checkinWithCode:) withObject:[metadataObject stringValue] waitUntilDone:NO];
        }
        
        if(audioPlayer) {
            [audioPlayer play];
        }
    }
}
- (IBAction)flashLightToggle:(id)sender {
    NSLog(@"FLASH LIGHT");
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if ([flashLight isTorchActive])
            {
                [btnFlash setImage:[UIImage imageNamed:@"icon_flashlight_on"] forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            else
            {
                [btnFlash setImage:[UIImage imageNamed:@"icon_flashlight_off"] forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }
}

#pragma mark - Scanning

-(BOOL)startScanning {
    btnFlash.enabled = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if(!deviceInput) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:deviceInput];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:supportedMetaTypes];
    
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:viewPreview.layer.bounds];
    [viewPreview.layer addSublayer:videoPreviewLayer];
    
    [captureSession startRunning];
    
    return YES;
}

-(void)stopScanning {
    [captureSession stopRunning];
    captureSession = nil;
    btnFlash.enabled = NO;
    
//    [videoPreviewLayer removeFromSuperlayer];
}

-(void)loadBeepSound {
    NSString *beepPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepPath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if(error) {
        NSLog(@"Could not load Beep file");
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [audioPlayer prepareToPlay];
    }
}

- (void)showOverlayWithStatus:(BOOL)status
{
    if(status == YES) {
        imgStatusIcon.image = [UIImage imageNamed:@"success"];
        lblStatusTitle.text = @"SUCCESS";
        lblStatusText.text = @"TICKET WITH THIS CODE HAS BEEN CHECKED";
    } else {
        imgStatusIcon.image = [UIImage imageNamed:@"error"];
        lblStatusTitle.text = @"ERROR";
        lblStatusText.text = @"WRONG TICKET CODE";
    }
    [self.viewOverlayWrapper setHidden:NO];
}

-(void)checkinWithCode:(NSString*)checksum
{
    NSLog(@"TICKET CHECK %@", checksum);
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/check_in/%@?ct_json", [defaults stringForKey:@"baseUrl"], checksum];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [self showOverlayWithStatus:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showOverlayWithStatus:NO];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)back:(id)sender {
    [self stopScanning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
