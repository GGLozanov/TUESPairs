String getNotificationPartTwo(String notification) {
  if(notification.contains('You\'ve received a new match request from')) {
    return ' Check it out!';
  }
  if(notification.contains('You lost')) {
    return ' as a potential pair! Find a new one!';
  }
  if(notification.contains('You\'ve been unmatched by')) {
    return '! Find a new pair!';
  }
  if(notification.contains('You\'ve received a new message from')) {
    return '';
  } 
  if(notification.contains('Your match request has been accepted by')) {
    return '! Go and chat!';
  }
  return 'error';
}

String getNotificationPartOne(String notification) {
  if(notification.contains('You\'ve received a new match request from')) {
    return 'You\'ve received a new match request from ';
  }
  if(notification.contains('You lost')) {
    return 'You lost ';
  }
  if(notification.contains('You\'ve been unmatched by')) {
    return 'You\'ve been unmatched by ';
  } 
  if(notification.contains('You\'ve received a new message from')) {
    return 'You\'ve received a new message from ';
  } 
  if(notification.contains('Your match request has been accepted by')) {
    return 'Your match request has been accepted by';
  }
  return 'error';

}

String getNotificationKey(String notification) {
  if(notification.contains('You\'ve received a new match request from')) {
    return 'newRequestNotification';
  } 
  if(notification.contains('You lost')) {
    return 'lostPotentialPairNotification';
  } 
  if(notification.contains('You\'ve been unmatched by')) {
    return 'unmatchedNotification';
  } 
  if(notification.contains('You\'ve received a new message from')) {
    return 'newMessageNotification';
  } 
  if(notification.contains('Your match request has been accepted by')) {
    return 'matchRequestAcceptedNotification';
  }
  return 'unknownNotification';
}

String extractUsernameFromNotification(String notification) {

  String partOne = getNotificationPartOne(notification);
  String partTwo = getNotificationPartTwo(notification);
  if(partOne == 'error' || partTwo == 'error') {
    return ' ';
  }
  notification = notification.replaceAll(RegExp(partOne), '');
  notification = notification.replaceAll(RegExp(partTwo), '');

  return notification;

}
