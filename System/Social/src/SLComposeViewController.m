#import <Social/SLComposeViewController.h>
#import <UIKit/UIKit.h>

NSString *const SLServiceTypeFacebook = @"facebook";
NSString *const SLServiceTypeTwitter = @"twitter";
NSString *const SLServiceTypeSinaWeibo = @"sinaWeibo";
NSString *const SLServiceTypeTencentWeibo = @"tencentWeibo";

@implementation SLComposeViewController

+ (SLComposeViewController *)composeViewControllerForServiceType:(NSString *)serviceType
{
    return [[SLComposeViewController alloc] initForServiceType:serviceType];
}

+ (BOOL)isAvailableForServiceType:(NSString *)serviceType
{
    return [serviceType isEqualToString:SLServiceTypeFacebook] || [serviceType isEqualToString:SLServiceTypeTwitter];
}

- (instancetype)initForServiceType:(NSString *)serviceType
{
    self = [super init];
    if(self) {
        // self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _serviceType = serviceType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([_serviceType isEqualToString:SLServiceTypeTwitter]) {
        [self _prepareTweetView];
    } else if([_serviceType isEqualToString:SLServiceTypeFacebook]) {
        
    } else {
        assert(0);
    }
    
}

- (void)_prepareTweetView
{
    UIView *view = self.view;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(30,115,260,260)];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.cornerRadius = 10;
    [view addSubview:rootView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 40)];
    titleLabel.text = @"Twitter";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
//    titleLabel.backgroundColor = [UIColor redColor];
    [rootView addSubview:titleLabel];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 0, 80, 40)];
    [closeButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    closeButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.backgroundColor = [UIColor blueColor];
//    closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rootView addSubview:closeButton];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+5, 240, 200)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://twitter.com/intent/tweet"]]];
    [rootView addSubview:webview];
}

- (void)closeWindow:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)setInitialText:(NSString *)text
{
    return NO;
}

- (BOOL)addImage:(UIImage *)image
{
    return NO;
}

- (BOOL)removeAllImages
{
    return NO;
}

- (BOOL)addURL:(NSURL *)url
{
    return NO;
}

- (BOOL)removeAllURLs
{
    return NO;
}
@end
