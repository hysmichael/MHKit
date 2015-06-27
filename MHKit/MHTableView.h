//
//  ActionlistView.h
//  MHKit
//
//  Created by Michael Hong on 1/23/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

/* MHTableView is a subclass of UITableView that has been
 extensively used in all ME tab controllers.
 
 MHTableView handles most of the boilerplate work (cell registration,
 cell initialization, UITableView delegate methods, datasource methods)
 and provides a fast and clean way to create a mostly-static tableview
 (like those used in setting pages).
 
 instead of fully delegate the data source, MHTableView handles the
 datasource and hides all cell storage behind the scene. one can set
 up a list of items by sequentially adding sections and rows to MHTableView
 where there sections and rows will be stacked in order and the correct
 section count and row count will be fed to UITableView. 
 
 moreover, one can provide a customized cell class as which a new cell
 will be allocated and/or a customized height for a certain row. and two
 delegate methods are provided for an object that abiding by MHTableViewDelegate
 protocal to further render a cell and handle cell actions.
 
 regarding the limitation of MHTableView, because it abstracts away 
 delegate and datasource of UITableView, applications that rely on more
 advanced delegate methods of UITableView might find MHTableView crippled. 
 and more generally, because the structure of the sections and rows
 can not be changed once initialized, and the height of any row is fixed
 once provided (though exceptions apply for subclass of UITableViewCell_Auto),
 functionality that rely heavliy upon a full-fledged dynamic tableview might
 be impossible with MHTableView.

*/

@protocol MHTableViewDelegate <NSObject>
@optional
- (void) renderCellContents: (UITableViewCell *)cell atSection:(NSUInteger)section atRow:(NSUInteger)row;
- (void) registerCellActionsAtSection:(NSUInteger)section atRow:(NSUInteger)row;
@end

@interface MHTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

-(instancetype) initWithStyle:(UITableViewStyle)style delegate:(id<MHTableViewDelegate>)delegate;

@property (weak) id<MHTableViewDelegate> mh_delegate;
@property BOOL showSectionHeader;

/* if showSectionHeader is set to TRUE, then section names will be 
 displayed as section headers. otherwise, no headers are displayed.
 The spacing between sections, especially evident in grouped tableviews,
 is controlled by sectionSpacing and exteriorSpacing. The difference 
 between the two is illustrated as the following:
 
 TOP EDGE OF THE SCROLL VIEW CONTENT
 ------------------------
                              <<< exteriorSpacing
 ------ SECTION 1 -------
 ...
 --- END OF SECTION 1 ---
                              <<< sectionSpacing
 ------ SECTION 2 -------
 ...
 --- END OF SECTION 2 ---
                              <<< sectionSpacing
 ...
                              <<< sectionSpacing
 ------ SECTION N -------
 ...
 --- END OF SECTION N ---
                              <<< exteriorSpacing
 ------------------------
 BOTTOM EDGE OF THE SCROLL VIEW CONTENT */
@property CGFloat sectionSpacing;
@property CGFloat exteriorSpacing;

/* section names are used as section headers (when showSectionHeader is set to TRUE)
 and row names are used as text of textLabel in a tableview cell (though the value
 can be overwritten by renderCellContents)
 
 however,
 there are several interpretable suffixes to a section or a row's name.
  an asterisk * means that the section or the row name will not be used as section
 header or tableview cell table text.
  an exclaimation mask ! means that row cell, if a subclass of UITableViewCell_Editable,
 must be deemed non-empty (required) to be marked as validated. */

-(void) addSection:(NSString *)name;

-(void) addRow:(NSString *)name;
-(void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString;
-(void) addRow:(NSString *)name cellClassString:(NSString *)cellClassString height:(CGFloat)height;

/* these editing methods heavily depend on a UITableViewCell_Editable's subclass's
 implementation. 
 
 note that UITableView deallocs a cell (or stacks away for reuse later) when it is
 removed from the screen to increase scrolling performance. however, this behavior
 causes the edited states of a cell lost were its values not stored somewhere before
 it gets deallocated. MHTableView keeps track of the values of all editable cells
 and make sure their lastest values are preserved when they go out of the screen and
 are deallocated. */

-(void) activateFirstEditingView;
-(void) resignAllEditingViews;
-(BOOL) validateAllEditingViews;
-(id)   postEditValueForEditableCellAtSection:(NSInteger)section atRow:(NSInteger)row;

@end


