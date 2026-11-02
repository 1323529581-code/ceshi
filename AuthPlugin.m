#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>

static BOOL hasShownMyAlert = NO;
static BOOL isAuthorizedFlag = NO;
static BOOL hasLoadedCheat = NO;

// --- 300个授权码 ---
NSArray *getValidCodes() {
    static NSArray *codes = nil;
    if (!codes) {
        codes = @[
            @"DAY-010XZ-2WNDE", @"DAY-05BY8-A5AT3", @"DAY-06HQ3-N51W3", @"DAY-0H6Y4-PZTRY", @"DAY-0RKAF-DC8MT",
            @"DAY-12R7O-W5ZAC", @"DAY-13IMD-ZW9Z2", @"DAY-1LG22-11BGP", @"DAY-1LKOQ-MPKR2", @"DAY-1ZY8Z-CG4JH",
            @"DAY-2FZW3-60L4R", @"DAY-2VYYD-MPGHY", @"DAY-3GNXF-5TGTS", @"DAY-3W00K-QA1MT", @"DAY-4B4MC-OWLI4",
            @"DAY-4Z9GP-8PLXL", @"DAY-5DPTM-TAIU2", @"DAY-5JE31-8SAK4", @"DAY-5SEEB-BX9PM", @"DAY-6UOXE-LKP92",
            @"DAY-6YH0E-LHAQT", @"DAY-769HC-LK9N7", @"DAY-7LBFV-30DHG", @"DAY-7YR53-5P1CN", @"DAY-86PSV-DN1Z6",
            @"DAY-8NWIO-EADO6", @"DAY-8SPIG-UEE8J", @"DAY-8ZZC3-43IYM", @"DAY-93A2W-Q3CE7", @"DAY-9WQGS-QCOSD",
            @"DAY-AFA8W-S1N42", @"DAY-AMU10-NLTKU", @"DAY-AWQPU-FDL9R", @"DAY-BKGQ5-JHHG4", @"DAY-BNW82-2VK4H",
            @"DAY-BRM6C-YS55W", @"DAY-BSLIW-I8XOI", @"DAY-BZD66-YB0YB", @"DAY-C1U3C-AZHN2", @"DAY-CYPPZ-3U7L7",
            @"DAY-D57M6-E0812", @"DAY-DGKMG-DIIQP", @"DAY-DPMG4-ZJ2EY", @"DAY-EM3C8-3T29Y", @"DAY-EZGM2-RR1I1",
            @"DAY-G26U3-JBLVX", @"DAY-GAEFN-1PA19", @"DAY-GBC7J-P8YDU", @"DAY-GC5ZC-GQGA9", @"DAY-GOWHW-BZHSK",
            @"DAY-H1PYO-H2DCJ", @"DAY-H7FZJ-ZKTDF", @"DAY-HB9OD-5HTMJ", @"DAY-HEE3P-RHBEH", @"DAY-HIWY0-L1734",
            @"DAY-HN913-D6IO7", @"DAY-I8W2V-WRVCI", @"DAY-IP1U0-AOEP4", @"DAY-ITV94-6CCKZ", @"DAY-K0QUB-G1MKC",
            @"DAY-L0SHA-NZ6O0", @"DAY-LDKPA-TWL57", @"DAY-LW1I9-0KQ0M", @"DAY-M6GN8-0L094", @"DAY-NNSKL-3D0D7",
            @"DAY-NWV9C-FHABE", @"DAY-OT794-QGTZN", @"DAY-PAT93-EZ2RQ", @"DAY-QCZVH-QABT6", @"DAY-QYEFM-BR3HD",
            @"DAY-R1F25-DXOWK", @"DAY-R88L3-MH4LD", @"DAY-RFQ5U-SNNM5", @"DAY-RM3IA-MWW95", @"DAY-S86HY-16RH2",
            @"DAY-S9G7E-JPKUK", @"DAY-SAMQ4-J9SVU", @"DAY-SDNS8-AFQ2Z", @"DAY-SI3OE-P8I7X", @"DAY-SMV73-WGP98",
            @"DAY-SP64Q-QPOG4", @"DAY-SSTT7-671YZ", @"DAY-TC1T3-SH9CA", @"DAY-TH7EV-32SP5", @"DAY-TLHXB-OQ4XN",
            @"DAY-TMTAF-2J7FT", @"DAY-UDWUI-ME32O", @"DAY-V0PTR-02OP2", @"DAY-V43TR-AKOXA", @"DAY-V6TE3-DLF3W",
            @"DAY-V9IR8-FO6LP", @"DAY-VL4WG-OXZ44", @"DAY-WCQ4V-48923", @"DAY-WDPJH-2JVHU", @"DAY-XN4SI-F5JS4",
            @"DAY-Y0TB1-WSL0U", @"DAY-YSES8-KDSUI", @"DAY-Z3UU3-1D2UB", @"DAY-Z71BF-2T29M", @"DAY-ZMDDZ-SSJFM",
            
            @"MON-04SOM-SSBJZ", @"MON-09I2O-PUFWG", @"MON-0FIUU-DUYVB", @"MON-0NF4D-KLFYB", @"MON-0RFI2-DGE1E",
            @"MON-2AJ1G-K016Z", @"MON-2BFZY-EI4JP", @"MON-2EE1U-TI1PC", @"MON-2G4ER-UVF9N", @"MON-2QR4K-VQS9I",
            @"MON-2RK7G-O5PAY", @"MON-3XYJS-PBN37", @"MON-491G-3CN6Q", @"MON-5446W-SCC6Q", @"MON-5OG51-EU0QU",
            @"MON-5P6IL-ZMSKT", @"MON-61IOP-PX1K3", @"MON-61RS4-ALPSB", @"MON-69LN4-96WDW", @"MON-6L2IS-L1FU5",
            @"MON-6V6YU-91OGD", @"MON-75CZY-B8D2Z", @"MON-7GT0O-75VAJ", @"MON-7IDMT-XZ8KC", @"MON-7P7PS-CDZNB",
            @"MON-80QHS-YBRP7", @"MON-8CKN9-G85NA", @"MON-8J4KB-QH3YR", @"MON-9EG0Z-C040S", @"MON-A2JN4-DLDOX",
            @"MON-B9OEM-ZZJGX", @"MON-BRFYZ-8A78V", @"MON-BUCS2-USY9W", @"MON-BWZ5Z-D2OTY", @"MON-C2DY6-F5LZT",
            @"MON-CFA5O-13CIO", @"MON-CMUQ0-EU4KB", @"MON-CSAPG-XLHML", @"MON-DBBZO-I23Q7", @"MON-DJ2RD-0Z7FT",
            @"MON-DJKOP-6UG1D", @"MON-EM3SC-XBV56", @"MON-F1V6P-9K62R", @"MON-FXVRO-JH9VF", @"MON-GBBOH-V1A8G",
            @"MON-GIBPE-TGVY4", @"MON-GIGPV-7D9PT", @"MON-GZLIJ-U49MK", @"MON-H97QR-KPUHZ", @"MON-HHPRS-5UPXI",
            @"MON-HLH65-5DBP5", @"MON-HPRKO-52KC4", @"MON-HWBHD-KXJVG", @"MON-I0HX1-XHRZL", @"MON-I6476-GSU4K",
            @"MON-IJ52T-88WUX", @"MON-JF6IG-A4GS8", @"MON-JGG3R-W3H34", @"MON-JK8GC-MGYK6", @"MON-JT0V2-SBOCC",
            @"MON-K174U-PK1NP", @"MON-KBKJI-JSM0I", @"MON-KE61H-JM0E3", @"MON-KFY45-C6OHD", @"MON-KKXR5-O29M7",
            @"MON-L53S1-WN0GW", @"MON-LTIJO-L7BMA", @"MON-M0KVS-CD3HQ", @"MON-MDEGR-RKWXE", @"MON-MQXSD-O8865",
            @"MON-MRHGK-OG95I", @"MON-NQ3N1-XYH0N", @"MON-O6HLZ-SZABY", @"MON-OS84L-KL94W", @"MON-OSBNW-0STZM",
            @"MON-OWKMC-NUKMY", @"MON-OYS6G-P57BJ", @"MON-P0FMA-OHJWM", @"MON-P516H-EBVKC", @"MON-P8YD2-D58Q7",
            @"MON-PFGGC-G8APJ", @"MON-PVDNW-93O0G", @"MON-QAC4J-02F5P", @"MON-QKQFU-QRJOI", @"MON-QU4AR-WEI0W",
            @"MON-R928E-CAAXC", @"MON-RSHHP-2RH56", @"MON-RYU42-KN37J", @"MON-SCCHE-COWLQ", @"MON-SMFRU-ACYMJ",
            @"MON-SNKGN-EU99G", @"MON-SXB9Z-KDVB7", @"MON-SYV74-46BC1", @"MON-U59ZT-DM07D", @"MON-UHC5U-YDLQF",
            @"MON-VOLG0-GKOGX", @"MON-W9N6V-35BOL", @"MON-WAYHC-R2B6T", @"MON-X647P-Q9PLR", @"MON-YKKL9-PVHP0",
            
            @"PER-0AVW4-KRYF8", @"PER-0KPG1-9EXOF", @"PER-1HK6F-L6FPY", @"PER-1JXH0-G1N28", @"PER-2989F-D6698",
            @"PER-2I0KC-22JG9", @"PER-3YY40-50Z99", @"PER-4O0CX-MTRSV", @"PER-55862-O189R", @"PER-5HCPF-2QPYT",
            @"PER-615PA-GRXFY", @"PER-6E661-DN008", @"PER-6RT5K-SY959", @"PER-6ZYHE-R9HS1", @"PER-70TQZ-UQDBH",
            @"PER-71XM2-INFGL", @"PER-7CV6K-GMN0K", @"PER-7NIZ2-LORYH", @"PER-820A7-YB5HX", @"PER-8AS5F-53W1E",
            @"PER-8VU79-YTAGX", @"PER-8Z9VL-4EX76", @"PER-AFQ6L-RQKSQ", @"PER-B0FX3-R85PU", @"PER-BBMB4-3109S",
            @"PER-BGHKA-XONCZ", @"PER-BH8LT-5ON81", @"PER-BL4K5-REN8B", @"PER-CNKQQ-HJW8F", @"PER-DE84V-G54KW",
            @"PER-E3N9V-D3SZ0", @"PER-EDJDV-492HS", @"PER-ELNUO-X1OQ3", @"PER-EUC63-H7QOD", @"PER-F2C7U-IXQ6M",
            @"PER-F7I39-E4OAT", @"PER-FY34V-PNGKZ", @"PER-G1LY5-V3ORH", @"PER-GCVG5-W43EU", @"PER-GEDDG-SSF6B",
            @"PER-H28E5-8E7B8", @"PER-H3YZ5-D1IFK", @"PER-HSRNL-O8T4V", @"PER-HSZF8-XT7JB", @"PER-I1NC7-C78XV",
            @"PER-IFDBN-TSJRI", @"PER-IPVCM-J3ZJS", @"PER-IW505-ITY8G", @"PER-J1G26-X2LBY", @"PER-JAKWM-4SQMX",
            @"PER-JQ3HV-BFQ60", @"PER-KQXMX-M9OYA", @"PER-LFR0D-SPV3A", @"PER-LHR8W-4XK05", @"PER-LNVX3-39X2G",
            @"PER-M05FV-KZURA", @"PER-MEHX6-UZ0LV", @"PER-NC507-LT0R8", @"PER-NV1DS-RU82U", @"PER-OMURC-7CYHT",
            @"PER-ONGDQ-GBEU6", @"PER-ORH8V-650DZ", @"PER-P3827-H2X5T", @"PER-P9DN4-6RGJA", @"PER-PII9C-NWNNA",
            @"PER-QVEF9-95B7V", @"PER-QXKUO-0MZLT", @"PER-R2SDS-6YBKR", @"PER-R5VO4-K83BT", @"PER-RAL1J-0B8TU",
            @"PER-RM6CI-ZGCN0", @"PER-RVLDY-7NMY7", @"PER-S4XSB-X9GSS", @"PER-STCXP-KVIOJ", @"PER-STQL3-MA99J",
            @"PER-SUXO1-JS3UA", @"PER-TPVGM-HKZEN", @"PER-U6ZKY-X4VDI", @"PER-U7MEM-DSJFG", @"PER-UFGEZ-QHDG8",
            @"PER-UFWR3-3HWOA", @"PER-UMIJZ-TUTWF", @"PER-UNAN8-GG2VD", @"PER-V29CE-ZH2OA", @"PER-VEGA8-ET6Y5",
            @"PER-VGERT-D45YE", @"PER-VKGAD-0Z1KF", @"PER-W8SKK-JIZIX", @"PER-WERVC-TKZ0I", @"PER-WLGI2-VZQNT",
            @"PER-WS263-VWNCU", @"PER-X51RG-ZH0FL", @"PER-Y6Q3Z-4HOXU", @"PER-Y7NCA-QPYXC", @"PER-YPFSF-R1311",
            @"PER-YSC2E-QRXVH", @"PER-YWG29-6JT1A", @"PER-ZNXWS-NW0FI", @"PER-ZT6J0-L6U1A", @"PER-ZU4NT-1WRNZ"
        ];
    }
    return codes;
}

BOOL isAuthorized() {
    return isAuthorizedFlag || [[NSUserDefaults standardUserDefaults] boolForKey:@"GameAuth_Activated"];
}

void loadRealCheatDylib() {
    if (hasLoadedCheat) return;

    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dylibPath = [bundlePath stringByAppendingPathComponent:@"libStarlust.dylib"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
        return; // 文件不存在就静默失败
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        void *handle = dlopen([dylibPath UTF8String], RTLD_LAZY);
        
        if (handle) {
            hasLoadedCheat = YES;
            NSLog(@"[AuthPlugin] 外挂加载成功，正在唤醒 UI...");
            
            // 【关键】伪造游戏启动和活跃通知，强制唤醒外挂内部的 UI 初始化代码
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeVisibleNotification object:nil];
            });
        } else {
            NSLog(@"[AuthPlugin] 外挂加载失败: %s", dlerror());
        }
    });
}

UIViewController *getTopViewController() {
    UIViewController *rootVC = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.rootViewController) {
            rootVC = window.rootViewController;
            break;
        }
    }
    if (!rootVC) return nil;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    return rootVC;
}

void showMyAuthAlert() {
    UIViewController *rootVC = getTopViewController();
    if (!rootVC) return;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"授权验证"
                                                                   message:@"请输入激活码以使用辅助功能："
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"输入激活码";
        textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }];
    
    UIAlertAction *activateAction = [UIAlertAction actionWithTitle:@"激活" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *inputCode = alert.textFields.firstObject.text;
        inputCode = [inputCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([getValidCodes() containsObject:inputCode]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameAuth_Activated"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isAuthorizedFlag = YES;
            
            // 【修改】验证成功后，直接关闭验证框，不留任何多余的提示
            [alert dismissViewControllerAnimated:YES completion:^{
                // 然后在后台加载外挂
                loadRealCheatDylib();
            }];
            
        } else {
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"激活码错误" message:@"请检查输入是否正确。" preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 350000000), dispatch_get_main_queue(), ^{
                    showMyAuthAlert();
                });
            }]];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"不使用辅助" style:UIAlertActionStyleCancel handler:nil]];
            [rootVC presentViewController:errorAlert animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不使用辅助" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:activateAction];
    [alert addAction:cancelAction];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

__attribute__((constructor))
static void initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000000000), dispatch_get_main_queue(), ^{
        if (isAuthorized()) {
            // 如果之前激活过，直接静默加载
            loadRealCheatDylib();
        } else if (!hasShownMyAlert) {
            hasShownMyAlert = YES;
            showMyAuthAlert();
        }
    });
}
