//
//  MusicaViewController.h
//  tcplay
//
//  Created by Tiago Barufi on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicaViewController : UITableViewController{
    NSMutableData *responseData;
    NSMutableArray *rows;
}
@property (nonatomic, strong) NSMutableArray *songs;
@end