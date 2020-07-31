@interface MTAAlarmEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, auroreSnoozeDelegate>
// ^ really important
@end

%hook MTAAlarmEditViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if (self.auroreEnabled) {
			return 6;
		}
		return 5;
	} else {
		return %orig;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 2) {
			UITableViewCell *auroreSwitchCell = %orig(tableView, [NSIndexPath indexPathForRow:3 inSection:0]);
			auroreSwitchCell.textLabel.text = @"Music";

			UISwitch *auroreSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
			[auroreSwitch setOn:self.auroreEnabled animated:NO];
			[auroreSwitch addTarget:self action:@selector(auroreSwitchChanged:) forControlEvents:UIControlEventValueChanged];
			auroreSwitchCell.accessoryView = auroreSwitch;

			return auroreSwitchCell;
	}
	return %orig;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (self.auroreEnabled) {
			if (indexPath.row == 2) {
				auroreSnoozeTableViewController *snoozeTableController = [[auroreSnoozeTableViewController alloc] initWithSettings:self.auroreSettings inset:globInset isSleep:NO];
				snoozeTableController.delegate = self;
				[self.navigationController pushViewController:snoozeTableController animated:YES];
			} else {
				%orig;
			}
	} else {
		%orig;
	}
}

%new
- (void)auroreSwitchChanged:(UISwitch *)auroreSwitch {
// do some shit here to save boolean to plist
}

%new
- (void)auroreSnoozeTableControllerUpdateSnoozeEnabled:(NSNumber *)snoozeEnabled snoozeCount:(NSNumber *)snoozeCount snoozeTime:(NSNumber *)snoozeTime snoozeVolume:(NSNumber *)snoozeVolume snoozeVolumeTime:(NSNumber *)snoozeVolumeTime {
	self.auroreSettings[@"snoozeEnabled"] = snoozeEnabled;
	self.auroreSettings[@"snoozeCount"] = snoozeCount;
	self.auroreSettings[@"snoozeTime"] = snoozeTime;
	self.auroreSettings[@"snoozeVolume"] = snoozeVolume;
	self.auroreSettings[@"snoozeVolumeTime"] = snoozeVolumeTime;
	self.auroreSettingsChanged = YES;
}

%end
