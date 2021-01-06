//  ViewController.m
//
//  Created by David Phillip Oster on 6/8/20.
//  Copyright © 2020 David Phillip Oster. All rights reserved.
// Open Source under Apache 2 license. See LICENSE in https://github.com/DavidPhillipOster/fileboss/ .
//

#import "ViewController.h"

@interface ViewController () <UIDocumentInteractionControllerDelegate>
@property(nonatomic) NSMutableArray *files;
@property(nonatomic) UIDocumentInteractionController *interactor;
@property(nonatomic) NSUInteger interactionIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setTitle:NSLocalizedString(@"File Boss", 0)];
  self.interactionIndex = NSNotFound;
  self.files = [NSMutableArray array];
  self.tableView.tableHeaderView = [self constructHeader];
  [self loadFiles];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
}

- (UIView *)constructHeader {
  CGRect r = UIScreen.mainScreen.bounds;
  r.size.height = 40;
  UIView *header = [[UIView alloc] initWithFrame:r];
  if (@available(iOS 13.0, *)) {
    header.backgroundColor = UIColor.secondarySystemFillColor;
  } else {
    header.backgroundColor = UIColor.lightGrayColor;
  }
  r = CGRectInset(r, 20, 0);
  UILabel *textLabel = [[UILabel alloc] initWithFrame:r];
  [header addSubview:textLabel];
  textLabel.numberOfLines = 0;
  textLabel.text = NSLocalizedString(@"Directions", 0);
  textLabel.textColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:1];
  textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  return header;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  UIView *v = self.tableView.tableHeaderView;
  UILabel *l = v.subviews.firstObject;
  CGRect frame = v.frame;
  CGSize siz = [l sizeThatFits:CGRectInset(frame, 20, 0).size];
  frame.size.height = siz.height;
  v.frame = frame;
}


- (void)didBecomeActive:(NSNotification *)note {
  [self loadFiles];
}

- (void)loadFiles {
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray<NSString *> *dirFiles = [fm contentsOfDirectoryAtPath:[self documentsPath] error:NULL];
  NSMutableArray<NSString *> *files = [NSMutableArray array];
  for (NSString *fileName in dirFiles) {
    if ([[fileName pathExtension] length] > 0) {
      [files addObject:fileName];
    }
  }
  [files sortUsingSelector:@selector(caseInsensitiveCompare:)];
  if ( ! [files isEqual:self.files]) {
    self.files = files;
    [self.tableView reloadData];
  }
}

- (NSString *)documentsPath {
  NSArray<NSString *> *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return dirs.firstObject;
}

- (void)deleteFileAtTableIndex:(NSUInteger)index {
  NSString *file = self.files[index];
  NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:file];
  NSFileManager *fm = [NSFileManager defaultManager];
  [fm removeItemAtPath:filePath error:NULL];
  [self.files removeObjectAtIndex:index];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 }

- (void)shareFileAtTableIndex:(NSUInteger)index {
  NSString *file = self.files[index];
  NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:file];
  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  [self setInteractor:[UIDocumentInteractionController interactionControllerWithURL:fileURL]];
  [self.interactor setDelegate:self];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  CGRect itemRect = [[self.tableView cellForRowAtIndexPath:indexPath] frame];
  self.interactionIndex = index;
  if ( ! [self.interactor presentOpenInMenuFromRect:itemRect inView:self.tableView animated:YES]) {
    // This probably can't happen, because some apps register to handle any kind of document.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unrecognized type", 0)
                                                                   message:NSLocalizedString(@"No apps for this", 0)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", 0)
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
      [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

#pragma mark -

- (UITableViewCell *)configureCell:(UITableViewCell *)cell index:(NSUInteger)index {
  cell.textLabel.text = self.files[index];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"a"];
    cell.textLabel.numberOfLines = 0;
  }
  return [self configureCell:cell index:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self shareFileAtTableIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self deleteFileAtTableIndex:indexPath.row];
  }
}

#pragma mark -

// Since we retained it in openInCommand, we release it here.
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
  [self setInteractor:nil];
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application {
  if (application.length && self.interactionIndex != NSNotFound) {
    [self deleteFileAtTableIndex:self.interactionIndex];
    self.interactionIndex = NSNotFound;
  }
}


@end
