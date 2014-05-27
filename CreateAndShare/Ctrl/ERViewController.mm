/*
 * Copyright 2013 Applifier
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "ERViewController.h"

#if USE_AUDIO
#if USE_FMOD
#import "fmod.hpp"
#import "fmod_errors.h"
#import "fmodiphone.h"

FMOD::System *fmod_system;
FMOD::Sound *sound1;
FMOD::Channel *channel;
#endif
#endif


@interface ERViewController ()

@property (nonatomic, retain) IBOutlet UIButton *everyplayButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *videoButton;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *modalButton;
@property (nonatomic, retain) IBOutlet UIButton *hudButton;
@property (nonatomic, retain) IBOutlet UIButton *faceCamButton;
@property (nonatomic) BOOL hudEnabled;

@property (nonatomic, retain) IBOutlet UIButton *play1Button;
@property (nonatomic, retain) IBOutlet UIButton *unload1Button;
@property (nonatomic, retain) IBOutlet UIButton *play2Button;
@property (nonatomic, retain) IBOutlet UIButton *unload2Button;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;
@property (nonatomic, retain) IBOutlet UIButton *resumeButton;
@property (nonatomic, retain) IBOutlet UIButton *rewindButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

@property (nonatomic, retain) IBOutlet UIButton *effect1Button;
@property (nonatomic, retain) IBOutlet UIButton *effect2Button;

@property (nonatomic) NSString *song1;
@property (nonatomic) NSString *song2;

@property (nonatomic) NSString *effect1;
@property (nonatomic) float effect1Pitch;
@property (nonatomic) NSString *effect2;
@property (nonatomic) float effect2Pitch;

@end

@implementation ERViewController

- (id)init
{
    if(self != nil){
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIView* view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
    
    //Everyplay recording
    [Everyplay setClientId:@"b459897317dc88c80b4515e380e1378022f874d2" clientSecret:@"f1a162969efb1c27aac6977f35b34127e68ee163" redirectURI:@"https://m.everyplay.com/auth"];
    
    [Everyplay initWithDelegate:self andParentViewController:self];

    //[Everyplay sharedInstance].flowControl = EveryplayFlowReturnsToVideoPlayer;

    _song1 = [NSString stringWithFormat:@"%@/loop.wav", [[NSBundle mainBundle] resourcePath]];
    _song2 = [NSString stringWithFormat:@"%@/loop2.wav", [[NSBundle mainBundle] resourcePath]];

    _effect1 = [NSString stringWithFormat:@"%@/Pew.caf", [[NSBundle mainBundle] resourcePath]];
    _effect2 = [NSString stringWithFormat:@"%@/Pow.caf", [[NSBundle mainBundle] resourcePath]];

    _effect1Pitch = 1.0f;
    _effect2Pitch = 1.0f;

    self.hudEnabled = YES;

#if USE_AUDIO
#if USE_FMOD
    FMOD_RESULT   result        = FMOD_OK;
    char          buffer[200]   = {0};
    unsigned int  version       = 0;

    result = FMOD::Debug_SetLevel(FMOD_DEBUG_LEVEL_NONE);
    result = FMOD::System_Create(&fmod_system);
    result = fmod_system->getVersion(&version);

    if (version < FMOD_VERSION) {
        fprintf(stderr, "You are using an old version of FMOD %08x.  This program requires %08x\n", version, FMOD_VERSION);
        exit(-1);
    }

    result = fmod_system->setSoftwareFormat(44100, FMOD_SOUND_FORMAT_PCM16, 1, 0, FMOD_DSP_RESAMPLER_LINEAR);

    FMOD_IPHONE_EXTRADRIVERDATA extradriverdata;
    memset(&extradriverdata, 0, sizeof(FMOD_IPHONE_EXTRADRIVERDATA));
    extradriverdata.sessionCategory = FMOD_IPHONE_SESSIONCATEGORY_AMBIENTSOUND;
    extradriverdata.forceMixWithOthers = false;

    result = fmod_system->init(32, FMOD_INIT_NORMAL, &extradriverdata);

    [_song1 getCString:buffer maxLength:200 encoding:NSASCIIStringEncoding];
    result = fmod_system->createSound(buffer, FMOD_SOFTWARE | FMOD_LOOP_NORMAL, NULL, &sound1);

    result = fmod_system->playSound(FMOD_CHANNEL_FREE, sound1, false, &channel);
#endif
#endif

    // Do any additional setup after loading the view, typically from a nib.
#if USE_EVERYPLAY
    [self createButtons];
#endif

}

- (void)viewDidUnload
{
    NSLog(@"ERview unloaded.");
    [super viewDidUnload];
  
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
    channel-> stop();
    sound1 -> release();
    fmod_system -> release();
    NSLog(@"Drawing view disappeared. Sound stopped.");
}


#pragma mark -

#if USE_EVERYPLAY

#define ADD_BUTTON(x, title, selector) \
  x = [UIButton buttonWithType:UIButtonTypeRoundedRect]; \
  x.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight); \
  [x setTitle:title forState: UIControlStateNormal]; \
  [x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; \
  [x setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted]; \
  [x addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside]; \
  [self.view addSubview:x];

- (void)createButtons {
    int buttonX = 10;
    int buttonY = 10;
    int buttonWidth = 200;
    int buttonHeight = 40;
    int padding = 8;

#if !USE_EVERYPLAY_AUDIO_BOARD
    ADD_BUTTON(_everyplayButton, @"Everyplay", @selector(everyplayButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_recordButton, @"Start recording", @selector(recordButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_videoButton, @"Test Video Playback", @selector(videoButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_modalButton, @"Show sharing modal", @selector(modalButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_loginButton, @"Login", @selector(loginButtonPressed:));
    [self updateLoginButtonState:_loginButton];

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_hudButton, @"HUD record off", @selector(hudButtonPressed:));
    _hudButton.hidden = NO;

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_faceCamButton, @"Request REC permission", @selector(faceCamButtonPressed:));
#else
    ADD_BUTTON(_play1Button, @"Play song #1", @selector(play1ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_unload1Button, @"Unload song #1", @selector(unload1ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_pauseButton, @"Pause song", @selector(pauseButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_resumeButton, @"Resume song", @selector(resumeButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_rewindButton, @"Rewind song", @selector(rewindButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_stopButton, @"Stop song", @selector(stopButtonPressed:));

    buttonY = 10;
    buttonX = buttonX + buttonWidth + padding;

    ADD_BUTTON(_play2Button, @"Play song #2", @selector(play2ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_unload2Button, @"Unload song #2", @selector(unload2ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_effect1Button, @"Effect #1", @selector(effect1ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_effect2Button, @"Effect #2", @selector(effect2ButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_recordButton, @"Start recording", @selector(recordButtonPressed:));

    buttonY = buttonY + buttonHeight + padding;
    ADD_BUTTON(_videoButton, @"Test Video Playback", @selector(videoButtonPressed:));
#endif
}

- (IBAction)everyplayButtonPressed:(id)sender {
    [[Everyplay sharedInstance] showEveryplay];
    NSLog(@"shown");
}

- (IBAction)recordButtonPressed:(id)sender {
    if ([[[Everyplay sharedInstance] capture] isRecording]) {
        [[[Everyplay sharedInstance] capture] stopRecording];
    } else {
        [[[Everyplay sharedInstance] capture] startRecording];
    }
}

- (IBAction)modalButtonPressed:(id)sender {
    [[Everyplay sharedInstance] showEveryplaySharingModal];
}

- (IBAction)videoButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;

    if ([button.titleLabel.text isEqualToString:@"Test Video Playback"] == YES) {
        NSURL *testUrl = [[NSURL alloc] initWithString:@"https://api.everyplay.com/videos?order=popularity&limit=1"];

        [[Everyplay sharedInstance] playVideoWithURL:testUrl];
    } else {
        [[Everyplay sharedInstance] playLastRecording];
    }
}

- (void)updateLoginButtonState:(id)sender {
    EveryplayAccount *account = [Everyplay account];

    if (account == nil) {
        [sender setTitle:@"Login" forState:UIControlStateNormal];
    } else {
        [account loadUserWithCompletionHandler:^(NSError *err, NSDictionary *user) {
            EveryplayLog(@"already logged in");
        }];
        [sender setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    EveryplayAccount *account = [Everyplay account];

    if (account == nil) {
        [Everyplay requestAccessforScopes:@"" withCompletionHandler:^(NSError *err) {
            if (EVERYPLAY_CANCELED(err)) {
                EveryplayLog(@"Canceled!");
            } else if (err) {
                EveryplayLog(@"Error: %@", [err localizedDescription]);
            } else {
                EveryplayLog(@"Logged in as:");
                [[Everyplay account] loadUserWithCompletionHandler:^(NSError *err, NSDictionary *user) {
                    EveryplayLog(@"%@",user);
                }];
            }
            [self updateLoginButtonState:sender];
        }];
    } else {
        [Everyplay removeAccess];
        [self updateLoginButtonState:sender];
    }
}

- (IBAction)hudButtonPressed:(id)sender {
    if (self.hudEnabled) {
        [_hudButton setTitle:@"HUD record on" forState:UIControlStateNormal];
        self.hudEnabled = NO;
    } else {
        [_hudButton setTitle:@"HUD record off" forState:UIControlStateNormal];
        self.hudEnabled = YES;
    }
}

- (IBAction)faceCamButtonPressed:(id)sender {
    EveryplayFaceCam *faceCam = [[Everyplay sharedInstance] faceCam];

    if (faceCam) {
        if (faceCam.isSessionRunning == NO) {
            if(recordingPermissionGranted) {
                [faceCam setPreviewOrigin: EVERYPLAY_FACECAM_PREVIEW_ORIGIN_BOTTOM_RIGHT];
                [faceCam setPreviewPositionX: 16];
                [faceCam setPreviewPositionY: 16];
                [faceCam setPreviewBorderWidth: 4.0f];
                [faceCam setPreviewSideWidth: 128.0f];
                [faceCam setPreviewScaleRetina: YES];

                // [faceCam setPreviewVisible: NO];
                // [faceCam setAudioOnly: YES];

                [faceCam startSession];
            }
            else {
                [faceCam requestRecordingPermission];
            }
        } else {
            [faceCam stopSession];
        }
    }
}

#pragma mark - Audio testing

- (void)play1ButtonPressed:(id)sender {
    NSLog(@"play1button pressed.");
    [[EveryplaySoundEngine sharedInstance] playBackgroundMusic:_song1 loop:YES];
}

- (void)unload1ButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] unloadBackgroundMusic:_song1];
}

- (void)play2ButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] playBackgroundMusic:_song2 loop:YES];
}

- (void)unload2ButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] unloadBackgroundMusic:_song2];
}

- (void)pauseButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] pauseBackgroundMusic];
}

- (void)resumeButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] resumeBackgroundMusic];
}

- (void)rewindButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] rewindBackgroundMusic];
}

- (void)stopButtonPressed:(id)sender {
    [[EveryplaySoundEngine sharedInstance] stopBackgroundMusic];
}

- (void)effect1ButtonPressed:(id)sender {
    _effect1Pitch += 0.1f;
    if (_effect1Pitch >= 2.0) {
        _effect1Pitch = 0.2f;
    }

    [[EveryplaySoundEngine sharedInstance] playEffect:_effect1 loop:NO pitch:_effect1Pitch pan:0.0f gain:1.0f];
}

- (void)effect2ButtonPressed:(id)sender {
    _effect2Pitch += 0.1f;
    if (_effect2Pitch >= 2.0) {
        _effect2Pitch = 0.2f;
    }

    [[EveryplaySoundEngine sharedInstance] playEffect:_effect2 loop:NO pitch:_effect2Pitch pan:0.0f gain:1.0f];
}

#pragma mark - Delegate Methods

- (void)everyplayFaceCamRecordingPermission:(NSNumber *)granted {
    if(granted) {
        recordingPermissionGranted = [granted boolValue];

        if(recordingPermissionGranted) {
            [_faceCamButton setTitle: @"Start FaceCam session" forState:UIControlStateNormal];
        }
    }
}

- (void)everyplayShown {
    ELOG;

#if USE_AUDIO
#if USE_FMOD
    channel->setMute(true);
#endif
    [[EveryplaySoundEngine sharedInstance] pauseBackgroundMusic];
#endif
}

- (void)everyplayHidden {
    ELOG;
#if USE_AUDIO
#if USE_FMOD
    channel->setMute(false);
#endif
    [[EveryplaySoundEngine sharedInstance] resumeBackgroundMusic];
#endif
}

- (void)everyplayRecordingStarted {
    ELOG;

    _hudButton.hidden = NO;
    [_recordButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
}

- (void)everyplayRecordingStopped {
    ELOG;

    _hudButton.hidden = YES;
    [_recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
    [_videoButton setTitle: @"Play Last Recording" forState: UIControlStateNormal];

    [[Everyplay sharedInstance] mergeSessionDeveloperData:@{@"testString" : @"hello"}];
    [[Everyplay sharedInstance] mergeSessionDeveloperData:@{@"testInteger" : @42}];
}

- (void)everyplayFaceCamSessionStarted {
    ELOG;
    [_faceCamButton setTitle:@"Stop FaceCam session" forState:UIControlStateNormal];
}

- (void)everyplayFaceCamSessionStopped {
    ELOG;
    [_faceCamButton setTitle:@"Start FaceCam session" forState:UIControlStateNormal];
}

- (void)everyplayUploadDidStart:(NSNumber *)videoId {
    EveryplayLog(@"Upload started for video %@", videoId);
}

- (void)everyplayUploadDidProgress:(NSNumber *)videoId progress:(NSNumber *)progress {
    EveryplayLog(@"Upload progress for video %@ = %@%%", videoId, progress);
}

- (void)everyplayUploadDidComplete:(NSNumber *)videoId {
    EveryplayLog(@"Upload completed for video %@", videoId);
}

#endif

@end
