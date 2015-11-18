//
//  DetailViewController.h
//  JSToOCDemo
//
//  Created by Harry on 15/11/18.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

