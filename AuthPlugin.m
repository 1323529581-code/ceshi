//
//  AuthPlugin.m
//  iOS 游戏激活码登录验证插件（本地验证版）
//
//  编译（Theos）:
//    TWEAK_NAME = AuthPlugin
//    AuthPlugin_FILES = AuthPlugin.m
//    AuthPlugin_FRAMEWORKS = UIKit Foundation
//    AuthPlugin_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
//
//  注入：全能签 -> 选 IPA -> 注入 AuthPlugin.dylib + AuthPlugin.plist
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <stdlib.h>
#import <string.h>

#pragma mark - ==================== 用户配置 ====================

// 同一台设备重复输入同一个码是否允许（YES = 允许，防止误删重装被锁）
static const BOOL kAllowSameDeviceReenter = YES;

// 输错时是否直接杀进程（YES 强杀，NO 仅关窗）
static const BOOL kExitOnWrongCode = YES;

#pragma mark - ==================== 内置激活码 ====================

// 《贤者同盟激活码.csv》共 300 个码：
//   DAY-*  → @0 日卡（首次激活 24 小时）
//   MON-*  → @1 月卡（首次激活 30 天）
//   PER-*  → @2 永久卡（不过期）
static NSDictionary<NSString *, NSNumber *> *ATBuildBuiltinCodes(void) {
    static NSDictionary<NSString *, NSNumber *> *dict;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dict = @{

            // ==================== 日卡 100 个 (24h) ====================
            @"DAY-0IXR4-TTCWW": @0,
            @"DAY-1AVXW-WA61S": @0,
            @"DAY-1KL0J-QPGZJ": @0,
            @"DAY-1NZPN-V39WQ": @0,
            @"DAY-228NJ-R08CE": @0,
            @"DAY-28EG0-UOQ1G": @0,
            @"DAY-2EYQF-Q0CEB": @0,
            @"DAY-2Q70Z-7NX60": @0,
            @"DAY-2SUFM-YOS0X": @0,
            @"DAY-36MR0-HRO4R": @0,
            @"DAY-3ALUP-07N3L": @0,
            @"DAY-3KEDI-C31ES": @0,
            @"DAY-3Z18M-1NSN7": @0,
            @"DAY-4A8XK-BJV7G": @0,
            @"DAY-56IO1-H98LQ": @0,
            @"DAY-598FS-DO7QO": @0,
            @"DAY-5YOVH-70GUB": @0,
            @"DAY-610HK-PIJBO": @0,
            @"DAY-8SDL0-NDZ4V": @0,
            @"DAY-8WDA3-PPEQ6": @0,
            @"DAY-93EB1-XDK3B": @0,
            @"DAY-96NX6-N1JBH": @0,
            @"DAY-98RR4-3HB4I": @0,
            @"DAY-9K3PF-JOTJB": @0,
            @"DAY-9MI78-LEIA6": @0,
            @"DAY-AAB5P-5D61G": @0,
            @"DAY-BD3LA-X3ES6": @0,
            @"DAY-CNYR6-N8WQN": @0,
            @"DAY-DDN10-ISW6B": @0,
            @"DAY-DJHLB-DVW0O": @0,
            @"DAY-E7UFC-AT1M4": @0,
            @"DAY-FJVOB-R0HZA": @0,
            @"DAY-FR2LB-J7ODG": @0,
            @"DAY-FZAXU-DTPTO": @0,
            @"DAY-G9PY0-I19W0": @0,
            @"DAY-GV6OS-4V2WB": @0,
            @"DAY-H5SXA-QTL7Q": @0,
            @"DAY-HLRN6-Q44N1": @0,
            @"DAY-HPR1X-BS0R2": @0,
            @"DAY-I3XB6-4L1WO": @0,
            @"DAY-IHLL7-P5UJH": @0,
            @"DAY-IQWBF-58Z3H": @0,
            @"DAY-IR7DB-ZSTF8": @0,
            @"DAY-IZ3LN-LLHIG": @0,
            @"DAY-JEZQ5-6NTCS": @0,
            @"DAY-JOBKG-G1BJZ": @0,
            @"DAY-JWXUQ-9WZ9X": @0,
            @"DAY-JYFVS-DR4X1": @0,
            @"DAY-K28RJ-M0UAQ": @0,
            @"DAY-KDHGQ-S212B": @0,
            @"DAY-KO8L9-80E99": @0,
            @"DAY-KRIRH-DHVOL": @0,
            @"DAY-KYVQY-193Q6": @0,
            @"DAY-LF99Z-W9QUK": @0,
            @"DAY-M4SKB-AAPH4": @0,
            @"DAY-M71Z2-AYK1A": @0,
            @"DAY-MPAIE-TB9D4": @0,
            @"DAY-MQ8YY-BTHCD": @0,
            @"DAY-MU594-0AGSS": @0,
            @"DAY-N0ZIV-ZNVAA": @0,
            @"DAY-N6NJS-Y5298": @0,
            @"DAY-NAJ5W-68DM4": @0,
            @"DAY-ONIND-8MNMF": @0,
            @"DAY-OO0QI-6WONU": @0,
            @"DAY-OWRVI-FMQHB": @0,
            @"DAY-P62EK-5E1JN": @0,
            @"DAY-P7FN2-EXY4S": @0,
            @"DAY-P9TM6-G0QW6": @0,
            @"DAY-PF060-3HNEX": @0,
            @"DAY-PTM2T-0VZQJ": @0,
            @"DAY-PVBB2-2V604": @0,
            @"DAY-PWJUG-N4WCV": @0,
            @"DAY-PX1EB-YFFNP": @0,
            @"DAY-Q6JMY-LJBLB": @0,
            @"DAY-RS9T1-GFZDV": @0,
            @"DAY-T2WHD-87HAO": @0,
            @"DAY-T36Z9-K0B59": @0,
            @"DAY-TBKF4-GG90F": @0,
            @"DAY-U2A68-JQLC4": @0,
            @"DAY-U7XZM-W7QL8": @0,
            @"DAY-UJ1HK-AVEXW": @0,
            @"DAY-UKBX3-UR5PD": @0,
            @"DAY-UOQ97-5HFQV": @0,
            @"DAY-UOZ39-3BLPM": @0,
            @"DAY-UTW0C-GHTOT": @0,
            @"DAY-V8AOR-6T18W": @0,
            @"DAY-VEYOW-QK2MI": @0,
            @"DAY-VLCH0-N6K3J": @0,
            @"DAY-VQQV7-WFOS6": @0,
            @"DAY-WCPEX-ALSQE": @0,
            @"DAY-WZRX7-YJRCK": @0,
            @"DAY-X0JDW-4II9L": @0,
            @"DAY-XQXIM-SMM1M": @0,
            @"DAY-Y7POR-WQW8S": @0,
            @"DAY-YG8VN-EZIJG": @0,
            @"DAY-Z4MPI-TGJ5F": @0,
            @"DAY-Z8TVT-1WTVB": @0,
            @"DAY-ZHES2-SKL5Q": @0,
            @"DAY-ZIMVU-GCQTH": @0,
            @"DAY-ZQBU9-3CTCV": @0,

            // ==================== 月卡 100 个 (30 天) ====================
            @"MON-0LOUA-DC8UW": @1,
            @"MON-1BOO2-70QBG": @1,
            @"MON-1M4D3-HOC8Z": @1,
            @"MON-1MDSD-2WX22": @1,
            @"MON-1TBPP-LTIT0": @1,
            @"MON-1ZWFJ-46F6U": @1,
            @"MON-278YB-W2WM5": @1,
            @"MON-39H2A-7CX37": @1,
            @"MON-3EO37-K449H": @1,
            @"MON-4D9Y2-RJVSG": @1,
            @"MON-4HBCV-58WN4": @1,
            @"MON-585E6-Q1XP1": @1,
            @"MON-5AW0B-G392V": @1,
            @"MON-5E2GC-P9IOB": @1,
            @"MON-5F7LM-4GCMU": @1,
            @"MON-5FSDO-ZYYKK": @1,
            @"MON-5H56S-C18X2": @1,
            @"MON-5O4QH-9SK4V": @1,
            @"MON-64SFW-VYUPG": @1,
            @"MON-65H5A-YPOEN": @1,
            @"MON-6JAXQ-R4ZRD": @1,
            @"MON-7LM54-VXGXC": @1,
            @"MON-7LVU2-J0L00": @1,
            @"MON-8UHRT-4WX3O": @1,
            @"MON-91K7W-OAI6A": @1,
            @"MON-9BQEF-9D09F": @1,
            @"MON-9R66K-98QQ3": @1,
            @"MON-9RHB6-88OMK": @1,
            @"MON-9RIA5-6FC1Y": @1,
            @"MON-A2G7Y-5Z792": @1,
            @"MON-ACGSU-0W90B": @1,
            @"MON-AK2XQ-P2OCI": @1,
            @"MON-B20EM-O6E57": @1,
            @"MON-B9NX6-IBLV8": @1,
            @"MON-C06DE-5CCJD": @1,
            @"MON-C0K7P-D7APO": @1,
            @"MON-C9JYZ-DAU1F": @1,
            @"MON-CJ8V3-RPYJD": @1,
            @"MON-CT49T-DIH7Y": @1,
            @"MON-CYG1S-0ZX28": @1,
            @"MON-CZ2JV-CNILY": @1,
            @"MON-D67Q3-ALW17": @1,
            @"MON-ES21Q-V7SWV": @1,
            @"MON-EUGL6-KFV71": @1,
            @"MON-FH1FA-DGVOH": @1,
            @"MON-FI17C-CFQ15": @1,
            @"MON-H6NIL-7QSJO": @1,
            @"MON-H7SF8-YSO9Y": @1,
            @"MON-I2EJ3-4B94T": @1,
            @"MON-ITXB6-PPUZA": @1,
            @"MON-J614B-A4N3D": @1,
            @"MON-JHWYD-NBXAM": @1,
            @"MON-JKDJ1-ORGI4": @1,
            @"MON-JOY17-38ENG": @1,
            @"MON-K54T1-HBP8C": @1,
            @"MON-KAYLM-EDO3Q": @1,
            @"MON-KXJCC-QJOE9": @1,
            @"MON-LI52Q-Q1RYW": @1,
            @"MON-MUFV4-0IK1P": @1,
            @"MON-N03VW-N55AM": @1,
            @"MON-N7QYY-VNF5N": @1,
            @"MON-NA200-X39MK": @1,
            @"MON-NFCV6-TWEAI": @1,
            @"MON-NUB62-EBN9K": @1,
            @"MON-NUH52-Y4LT6": @1,
            @"MON-NVF67-TRFG4": @1,
            @"MON-NY79H-731TC": @1,
            @"MON-O5OKR-RHMT8": @1,
            @"MON-O6Q1P-O61VW": @1,
            @"MON-O9ACB-5C4H0": @1,
            @"MON-OS865-W969K": @1,
            @"MON-OSQVN-Y05QS": @1,
            @"MON-OSW4M-XGP0F": @1,
            @"MON-PRTU1-JOC98": @1,
            @"MON-PTQ41-FUCFH": @1,
            @"MON-Q8ZRJ-H1S30": @1,
            @"MON-R115M-NVFG7": @1,
            @"MON-R27WP-AM7QX": @1,
            @"MON-REPVD-OMIDN": @1,
            @"MON-RWHWN-XNU97": @1,
            @"MON-S1YF6-DAK0W": @1,
            @"MON-SZU1T-Q9SA7": @1,
            @"MON-T6DNP-JNCSF": @1,
            @"MON-T91KC-ILDVL": @1,
            @"MON-TT9D8-3FUO9": @1,
            @"MON-U0E0F-TYIL7": @1,
            @"MON-U9SOT-1KS5V": @1,
            @"MON-V8AM9-HHNGY": @1,
            @"MON-VA3ZV-Z9083": @1,
            @"MON-VQ725-QQZMC": @1,
            @"MON-VWD60-7UFO8": @1,
            @"MON-W4XEW-IKR0Z": @1,
            @"MON-WSCTM-9ZTWS": @1,
            @"MON-X6UKT-U8HGT": @1,
            @"MON-XVMF2-5CX3I": @1,
            @"MON-Y8SE8-IRDBJ": @1,
            @"MON-YBJAY-A0XH8": @1,
            @"MON-Z7E80-WX5U4": @1,
            @"MON-ZE21N-RQB4H": @1,
            @"MON-ZPJT1-6GC1M": @1,

            // ==================== 永久卡 100 个 ====================
            @"PER-0I1M2-7KKUL": @2,
            @"PER-0RPYT-VSSVR": @2,
            @"PER-184E0-HXEBG": @2,
            @"PER-1VY75-RBZ71": @2,
            @"PER-1XOZY-YR6UJ": @2,
            @"PER-2CMVV-FIM4M": @2,
            @"PER-2I8LE-TLRU8": @2,
            @"PER-2MSCP-MWJ1T": @2,
            @"PER-2OHD2-OGJLW": @2,
            @"PER-2T6KH-BUH6G": @2,
            @"PER-3037O-YEA3F": @2,
            @"PER-337XU-G8DF7": @2,
            @"PER-36A6M-DEYH7": @2,
            @"PER-3BWZ8-TEU4H": @2,
            @"PER-4D779-RPSHE": @2,
            @"PER-5J920-B1W0L": @2,
            @"PER-5NURD-WJOBK": @2,
            @"PER-6A7AU-Y7NAN": @2,
            @"PER-6JTG5-66LLN": @2,
            @"PER-6T6E9-QQGTV": @2,
            @"PER-7PMZ3-PDSKB": @2,
            @"PER-7ZXWZ-R9W81": @2,
            @"PER-83N58-JLIN5": @2,
            @"PER-8YLXQ-VTWJJ": @2,
            @"PER-8ZJZZ-EL52M": @2,
            @"PER-957Q4-F1CXB": @2,
            @"PER-9M6Y3-8AA3Z": @2,
            @"PER-9P797-JS1WL": @2,
            @"PER-AKVC1-TUL9A": @2,
            @"PER-ATLPD-SFX5O": @2,
            @"PER-AXDYB-69W7M": @2,
            @"PER-BMNTM-WLFVR": @2,
            @"PER-BNRRL-R3Q7E": @2,
            @"PER-BZWS6-J4UY2": @2,
            @"PER-C2X4S-QMRWP": @2,
            @"PER-CA2IZ-ZKWSB": @2,
            @"PER-CDSDZ-II3BR": @2,
            @"PER-DB9EJ-3NJYQ": @2,
            @"PER-DLK5C-DEVDN": @2,
            @"PER-DQOVG-XTZ9Z": @2,
            @"PER-DR54I-YK0DK": @2,
            @"PER-E05K5-5DG47": @2,
            @"PER-E2OKF-DZ68C": @2,
            @"PER-E77GT-LVTV6": @2,
            @"PER-FGFQ7-Z7AUX": @2,
            @"PER-G06KD-64UTX": @2,
            @"PER-G38NW-8XBE0": @2,
            @"PER-GGN46-LMSUA": @2,
            @"PER-GVFE0-STJTX": @2,
            @"PER-GZ9SV-4RZVN": @2,
            @"PER-H2NGN-QOWII": @2,
            @"PER-H7UIC-TXM74": @2,
            @"PER-HAWJJ-S8U44": @2,
            @"PER-IA148-6SC5I": @2,
            @"PER-ICHZX-BEHBQ": @2,
            @"PER-IPVJ0-GX5ZW": @2,
            @"PER-IYLUZ-4PIEW": @2,
            @"PER-JZ62M-19K5D": @2,
            @"PER-K2ZH7-M8UA3": @2,
            @"PER-K39IJ-46OT6": @2,
            @"PER-KEVGR-J4YCC": @2,
            @"PER-KHX5I-U6TQR": @2,
            @"PER-LM1JJ-XU2XG": @2,
            @"PER-MKW2B-E7X85": @2,
            @"PER-MZ8KW-ZZY5M": @2,
            @"PER-NA76D-T3KQC": @2,
            @"PER-O037A-0NZR9": @2,
            @"PER-OKARF-FR6D4": @2,
            @"PER-OQBZZ-D2KCT": @2,
            @"PER-PH82L-133WM": @2,
            @"PER-POEPX-ZMGFX": @2,
            @"PER-PZN4X-WZLVO": @2,
            @"PER-QCJ5V-U9GWA": @2,
            @"PER-QW7U1-UMM3A": @2,
            @"PER-R1VPV-2EE51": @2,
            @"PER-RCPFJ-BI37J": @2,
            @"PER-S4L7Q-7MFVG": @2,
            @"PER-SUP4W-2FWFA": @2,
            @"PER-TB7CD-W2LUS": @2,
            @"PER-TM81U-KHD3Z": @2,
            @"PER-TPO60-QEBO3": @2,
            @"PER-TQ7P9-YJS53": @2,
            @"PER-TYOJS-M65YV": @2,
            @"PER-U4DLV-WB0IR": @2,
            @"PER-UB7HP-RDE8N": @2,
            @"PER-UDWLJ-T2U89": @2,
            @"PER-UFVLF-3F6GZ": @2,
            @"PER-VKGOT-79BVU": @2,
            @"PER-VTTAC-ZC7DR": @2,
            @"PER-VXVYP-2AS2A": @2,
            @"PER-WJ2NC-L371Z": @2,
            @"PER-WSGS9-233G1": @2,
            @"PER-XBGB3-X2DFU": @2,
            @"PER-XYS09-T6Q8O": @2,
            @"PER-Y8F20-TCADM": @2,
            @"PER-YI3M0-BJPAV": @2,
            @"PER-YOUTM-CE381": @2,
            @"PER-YXRU8-OZ6HF": @2,
            @"PER-ZPIY0-KR4XK": @2,
            @"PER-ZSRZB-4RLC7": @2,
        };
    });
    return dict;
}

#pragma mark - ==================== 设备标识 ====================

static NSString *ATDeviceId(void) {
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuid ?: @"unknown-device";
}

#pragma mark - ==================== 本地数据库 ====================

// records.plist 结构：
// {
//   "DAY-XXXX-XXXX-XXXX" = {
//       type        = 0 / 1 / 2
//       deviceId    = "<uuid>"
//       activatedAt = <NSTimeInterval>
//       expiresAt   = <NSTimeInterval>   // -1 表示永久
//   }, ...
// }

static NSString *ATDBPath(void) {
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dir = [docs stringByAppendingPathComponent:@"ActivationDB"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return [dir stringByAppendingPathComponent:@"records.plist"];
}

static NSMutableDictionary *ATLoadRecords(void) {
    NSDictionary *raw = [NSDictionary dictionaryWithContentsOfFile:ATDBPath()];
    return raw ? [raw mutableCopy] : [NSMutableDictionary dictionary];
}

static void ATSaveRecords(NSDictionary *records) {
    [records writeToFile:ATDBPath() atomically:YES];
}

#pragma mark - ==================== 验证逻辑 ====================

typedef NS_ENUM(NSInteger, ATVerifyResult) {
    ATVerifySuccess = 0,
    ATVerifyEmpty,
    ATVerifyNotFound,
    ATVerifyUsedByOtherDevice,
    ATVerifyExpired,
};

static NSString *ATNormalizeCode(NSString *raw) {
    if (!raw) return @"";
    NSString *s = [raw uppercaseString];
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"－" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"—" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"–" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    return s;
}

static ATVerifyResult ATVerifyCode(NSString *rawCode,
                                   NSDictionary<NSString *, NSNumber *> *builtin,
                                   NSDictionary **outRecord)
{
    NSString *code = ATNormalizeCode(rawCode);
    if (code.length == 0) return ATVerifyEmpty;

    NSNumber *typeNum = builtin[code];
    if (!typeNum) return ATVerifyNotFound;

    NSInteger type = typeNum.integerValue;
    NSMutableDictionary *records = ATLoadRecords();
    NSString *deviceId = ATDeviceId();
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

    NSDictionary *existing = records[code];
    if (existing) {
        NSString *usedBy = existing[@"deviceId"];
        if (![usedBy isEqualToString:deviceId]) {
            return ATVerifyUsedByOtherDevice;
        }
        if (!kAllowSameDeviceReenter) {
            return ATVerifyUsedByOtherDevice;
        }
        double expTs = [existing[@"expiresAt"] doubleValue];
        if (expTs > 0 && expTs <= now) {
            return ATVerifyExpired;
        }
        if (outRecord) *outRecord = existing;
        return ATVerifySuccess;
    }

    // 首次激活
    NSTimeInterval duration = -1;
    if (type == 0)      duration = 24 * 60 * 60;          // 日卡 24h
    else if (type == 1) duration = 30 * 24 * 60 * 60;     // 月卡 30 天
    // type == 2：永久卡，duration = -1

    NSMutableDictionary *rec = [NSMutableDictionary dictionary];
    rec[@"type"]        = @(type);
    rec[@"deviceId"]    = deviceId;
    rec[@"activatedAt"] = @(now);
    rec[@"expiresAt"]   = (duration < 0) ? @(-1) : @(now + duration);

    records[code] = rec;
    ATSaveRecords(records);

    if (outRecord) *outRecord = [rec copy];
    return ATVerifySuccess;
}

// 当前设备是否有仍在有效期内的激活
static NSDictionary *ATCurrentSession(void) {
    NSDictionary *records = ATLoadRecords();
    NSString *deviceId = ATDeviceId();
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

    for (NSDictionary *rec in records.allValues) {
        if (![rec[@"deviceId"] isEqualToString:deviceId]) continue;
        double expTs = [rec[@"expiresAt"] doubleValue];
        if (expTs <= 0)  return rec;       // 永久卡
        if (expTs > now) return rec;       // 未过期
    }
    return nil;
}

#pragma mark - ==================== 顶层 VC ====================

static UIViewController *ATTopViewController(void) {
    UIWindow *keyWindow = nil;

    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                if (w.isKeyWindow) { keyWindow = w; break; }
            }
            if (keyWindow) break;
        }
    }
    if (!keyWindow) keyWindow = [UIApplication sharedApplication].keyWindow;

    UIViewController *top = keyWindow.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    return top;
}

#pragma mark - ==================== 登录界面 ====================

@interface ATLoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, copy) void (^onSuccess)(void);
@property (nonatomic, copy) void (^onAutoClose)(void);
@end

@interface ATLoginViewController ()
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIView *fieldContainer;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, assign) NSInteger secondsLeft;
@property (nonatomic, assign) BOOL submitted;
@property (nonatomic, copy)   NSDictionary<NSString *, NSNumber *> *builtin;
@end

@implementation ATLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.05 blue:0.10 alpha:0.96];
    self.builtin = ATBuildBuiltinCodes();
    [self setupUI];
    [self registerKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.codeField becomeFirstResponder];
    [self startAutoTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.autoTimer invalidate];
    self.autoTimer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UI

- (void)setupUI {
    self.cardView = [UIView new];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
    self.cardView.layer.cornerRadius = 20;
    self.cardView.layer.borderWidth = 1;
    self.cardView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.12].CGColor;
    [self.view addSubview:self.cardView];

    UILabel *icon = [UILabel new];
    icon.text = @"🔑";
    icon.font = [UIFont systemFontOfSize:44];
    icon.textAlignment = NSTextAlignmentCenter;

    UILabel *title = [UILabel new];
    title.text = @"激活验证";
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;

    UILabel *subtitle = [UILabel new];
    subtitle.text = @"请输入您的激活码（日卡 / 月卡 / 永久卡）";
    subtitle.font = [UIFont systemFontOfSize:13];
    subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.55];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.numberOfLines = 0;

    self.fieldContainer = [UIView new];
    self.fieldContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.fieldContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    self.fieldContainer.layer.cornerRadius = 12;
    self.fieldContainer.layer.borderWidth = 1;
    self.fieldContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;

    self.codeField = [UITextField new];
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.tintColor = [UIColor whiteColor];
    self.codeField.font = [UIFont monospacedSystemFontOfSize:16 weight:UIFontWeightMedium];
    self.codeField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.codeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.codeField.returnKeyType = UIReturnKeyDone;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.delegate = self;
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:@"DAY/MON/PER-XXXXX-XXXXX"
        attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3]}];
    [self.fieldContainer addSubview:self.codeField];

    self.verifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.verifyButton setTitle:@"立即验证" forState:UIControlStateNormal];
    self.verifyButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.verifyButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.55 blue:1.0 alpha:1];
    self.verifyButton.layer.cornerRadius = 12;
    [self.verifyButton addTarget:self action:@selector(onVerifyTapped)
               forControlEvents:UIControlEventTouchUpInside];

    self.hintLabel = [UILabel new];
    self.hintLabel.font = [UIFont systemFontOfSize:12];
    self.hintLabel.textColor = [UIColor colorWithWhite:1 alpha:0.45];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.numberOfLines = 0;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        icon, title, subtitle, self.fieldContainer, self.verifyButton, self.hintLabel
    ]];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 14;
    [stack setCustomSpacing:6  afterView:icon];
    [stack setCustomSpacing:20 afterView:subtitle];
    [stack setCustomSpacing:10 afterView:self.verifyButton];
    [self.cardView addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.cardView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-40],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:28],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-28],

        [stack.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:24],
        [stack.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:20],
        [stack.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-20],
        [stack.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-22],

        [self.fieldContainer.heightAnchor constraintEqualToConstant:52],
        [self.codeField.leadingAnchor constraintEqualToAnchor:self.fieldContainer.leadingAnchor constant:14],
        [self.codeField.trailingAnchor constraintEqualToAnchor:self.fieldContainer.trailingAnchor constant:-14],
        [self.codeField.topAnchor constraintEqualToAnchor:self.fieldContainer.topAnchor],
        [self.codeField.bottomAnchor constraintEqualToAnchor:self.fieldContainer.bottomAnchor],

        [self.verifyButton.heightAnchor constraintEqualToConstant:50],
    ]];
}

#pragma mark 5 秒倒计时

- (void)startAutoTimer {
    [self.autoTimer invalidate];
    self.secondsLeft = 5;
    [self updateHint];

    __weak typeof(self) weakSelf = self;
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *t) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) { [t invalidate]; return; }

        self.secondsLeft -= 1;
        if (self.secondsLeft <= 0) {
            [t invalidate];
            NSString *text = self.codeField.text ?: @"";
            if (text.length == 0) {
                [self autoClose];
            } else {
                self.hintLabel.text = @"";
            }
        } else {
            [self updateHint];
        }
    }];
}

- (void)updateHint {
    self.hintLabel.textColor = [UIColor colorWithWhite:1 alpha:0.45];
    self.hintLabel.text = [NSString stringWithFormat:@"无操作 %ld 秒后自动关闭", (long)self.secondsLeft];
}

- (void)autoClose {
    [self.autoTimer invalidate];
    if (self.submitted) return;
    void (^cb)(void) = self.onAutoClose;
    [self dismissViewControllerAnimated:YES completion:^{
        if (cb) cb();
    }];
}

#pragma mark 验证

- (void)onVerifyTapped {
    if (self.submitted) return;

    NSString *raw = self.codeField.text ?: @"";
    NSDictionary *rec = nil;
    ATVerifyResult r = ATVerifyCode(raw, self.builtin, &rec);

    switch (r) {
        case ATVerifySuccess: {
            self.submitted = YES;
            [self.autoTimer invalidate];
            self.hintLabel.text = @"✅ 激活成功";
            self.hintLabel.textColor = [UIColor systemGreenColor];
            [self.codeField resignFirstResponder];

            void (^cb)(void) = self.onSuccess;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    if (cb) cb();
                }];
            });
            break;
        }
        case ATVerifyEmpty:
            [self shake];
            self.hintLabel.text = @"请输入激活码";
            self.hintLabel.textColor = [UIColor systemOrangeColor];
            [self startAutoTimer];
            break;
        case ATVerifyNotFound:
            [self fail:@"激活码不存在"];
            break;
        case ATVerifyUsedByOtherDevice:
            [self fail:@"激活码已被使用"];
            break;
        case ATVerifyExpired:
            [self fail:@"激活码已过期"];
            break;
    }
}

- (void)fail:(NSString *)msg {
    self.submitted = YES;
    [self.autoTimer invalidate];
    self.codeField.enabled = NO;
    self.verifyButton.enabled = NO;
    self.hintLabel.text = [NSString stringWithFormat:@"❌ %@", msg];
    self.hintLabel.textColor = [UIColor systemRedColor];
    [self shake];

    if (!kExitOnWrongCode) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        exit(0);
    });
}

- (void)shake {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.values   = @[@(-10), @10, @(-8), @8, @(-5), @5, @0];
    anim.duration = 0.4;
    [self.cardView.layer addAnimation:anim forKey:@"shake"];
}

#pragma mark 键盘

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(kbShow:)
        name:UIResponder.keyboardWillShowNotification
        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(kbHide:)
        name:UIResponder.keyboardWillHideNotification
        object:nil];
}

- (void)kbShow:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    CGRect kbFrame = [info[UIResponder.keyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardTop = self.view.bounds.size.height - kbFrame.size.height;
    CGFloat overlap = CGRectGetMaxY(self.cardView.frame) - keyboardTop + 24;
    if (overlap <= 0) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.cardView.transform = CGAffineTransformMakeTranslation(0, -overlap);
    }];
}

- (void)kbHide:(NSNotification *)note {
    [UIView animateWithDuration:0.25 animations:^{
        self.cardView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self onVerifyTapped];
    return YES;
}

@end

#pragma mark - ==================== 激活管理器 ====================

@interface ATActivationManager : NSObject
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) BOOL done;
+ (instancetype)shared;
- (void)start;
@end

@implementation ATActivationManager

+ (instancetype)shared {
    static ATActivationManager *s;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s = [ATActivationManager new];
    });
    return s;
}

- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ATCurrentSession() != nil) {
            self.done = YES;
            return;
        }
        [self.timer invalidate];
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer *t) {
            [weakSelf tick];
        }];
        [self tick];
    });
}

- (void)tick {
    if (self.done || self.presenting) return;

    if (ATCurrentSession() != nil) {
        self.done = YES;
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    [self tryPresent];
}

- (void)tryPresent {
    UIViewController *top = ATTopViewController();
    if (!top || top.presentedViewController) return;

    self.presenting = YES;
    ATLoginViewController *vc = [ATLoginViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;

    __weak typeof(self) weakSelf = self;

    vc.onAutoClose = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        self.presenting = NO;
        if (!self.done) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [self tick];
            });
        }
    };

    vc.onSuccess = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        self.presenting = NO;
        self.done = YES;
        [self.timer invalidate];
        self.timer = nil;
    };

    [top presentViewController:vc animated:YES completion:nil];
}

@end

#pragma mark - ==================== 插件入口 ====================

__attribute__((constructor))
static void ATBootstrap(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [[ATActivationManager shared] start];
    });
}
