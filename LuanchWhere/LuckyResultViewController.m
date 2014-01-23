//
//  LuckyResultViewController.m
//  LuanchWhere
//
//  Created by 李帅 on 13-2-28.
//
//

#import "LuckyResultViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

typedef enum {
    ModelTypeOneByOne,//自我介绍模式，一个一个出现
    ModelTypeRandom,//抽奖模式，随机出现
    ModelTypeGame,//游戏模式，不显示名称
}ModelType;

@implementation LuckyResultViewController{
    NSString *_documentDirectoryPath;
    
    BOOL _rolling;
    ModelType _model;
    NSMutableArray *_indexArray;

}

- (void)loadView {
    self.view = self.resultImageView;
    _documentDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = ModelTypeOneByOne;
    [self changeModel];
    [self nextButton];
    [self applicationWillEnterForeground];
    if (_indexArray.count > 0) {
        [self turnToIndex:arc4random() % _indexArray.count];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)applicationWillEnterForeground {
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_documentDirectoryPath error:nil];
    _indexArray = [NSMutableArray arrayWithArray:array];
}

- (void)turnToIndex:(int)index {
    NSLog(@"%d",index);
    NSString *filename = [_indexArray objectAtIndex:index];
    NSData *data = [NSData dataWithContentsOfFile:[_documentDirectoryPath stringByAppendingPathComponent:filename]];
    self.resultImageView.image = [UIImage imageWithData:data];
    self.resultLabel.text = [filename stringByDeletingPathExtension];
    self.indexInfoLabel.text = [NSString stringWithFormat:@"(%d/%d)",index,_indexArray.count];
}
- (void)tap {
    if (_model != ModelTypeRandom) {
        if (_indexArray.count>1) {
            int index = arc4random() % _indexArray.count;
            [self turnToIndex:index];
            [_indexArray removeObjectAtIndex:index];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"这已经是最后一个了！" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        if (_indexArray.count == 0) {
            return;
        }
        _rolling = !_rolling;
        if (_rolling == YES) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^void(){
                while (_rolling == YES) {
                    int index = arc4random() % _indexArray.count;
                    dispatch_sync(dispatch_get_main_queue(), ^void(){
                        [self turnToIndex:index];
                    });
                }
            });
        }
    }
}
- (void)changeModel {
    if (_model == ModelTypeRandom) {
        _model = ModelTypeGame;
        [self.modelButton setTitle:@"游戏模式" forState:UIControlStateNormal];
    }else if(_model == ModelTypeGame){
        _model = ModelTypeOneByOne;
        [self.modelButton setTitle:@"介绍模式" forState:UIControlStateNormal];
    }else {
        _model = ModelTypeRandom;
        [self.modelButton setTitle:@"抽奖模式" forState:UIControlStateNormal];
    }
    
    if (_model == ModelTypeGame) {
        _resultLabel.alpha = 0;
    }else {
        self.resultLabel.alpha = 1;
    }
    
}

- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 60)];
        _resultLabel.textAlignment = UITextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:44];
        _resultLabel.textColor = [UIColor whiteColor];
        _resultLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _resultLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_resultLabel addGestureRecognizer:tapGesture];
        
        [self.resultImageView addSubview:_resultLabel];
    }
    
    return _resultLabel;
}
- (UIImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.backgroundColor = [UIColor blackColor];
        _resultImageView.userInteractionEnabled = YES;
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _resultImageView;
}
- (UILabel *)indexInfoLabel {
    if (!_indexInfoLabel) {
        _indexInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-50, 60, 40)];
        _indexInfoLabel.textAlignment = UITextAlignmentCenter;
        _indexInfoLabel.font = [UIFont systemFontOfSize:12];
        _indexInfoLabel.textColor = [UIColor whiteColor];
        _indexInfoLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_indexInfoLabel addGestureRecognizer:tapGesture];
        
        [self.resultImageView addSubview:_indexInfoLabel];
    }
    return _indexInfoLabel;
}
- (UIButton *)modelButton {
    if (!_modelButton) {
        _modelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _modelButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _modelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _modelButton.frame = CGRectMake(0,SCREEN_HEIGHT-50, 60, 40);
        [_modelButton addTarget:self action:@selector(changeModel) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_modelButton];
    }
    return _modelButton;
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _nextButton.frame = CGRectMake(SCREEN_WIDTH-60,SCREEN_HEIGHT-50, 60, 40);
        [_nextButton setTitle:@"下一个" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}
@end
