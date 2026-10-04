import 'package:flutter/material.dart';
import 'package:game_show_app/features/multi_language.dart';

class AppLocalizations {
  final String localeCode;

  const AppLocalizations(this.localeCode);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations('ar');
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  bool get isRtl =>
      localeCode == 'ar' || localeCode == 'ur' || localeCode == 'fa';

  String translate(String key) => LocalizedStrings.get(key, localeCode);
  String tr(String key) => translate(key);

  String get appName => translate('app_name');
  String get startGame => translate('start_game');
  String get winner => translate('winner');
  String get correctAnswer => translate('correct_answer');
  String get wrongAnswer => translate('wrong_answer');
  String get timeUp => translate('time_up');

  String get settings => translate('settings');
  String get language => translate('language');
  String get about => translate('about');
  String get exit => translate('exit');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get save => translate('save');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get back => translate('back');
  String get next => translate('next');
  String get done => translate('done');
  String get submit => translate('submit');
  String get score => translate('score');
  String get round => translate('round');
  String get question => translate('question');
  String get category => translate('category');
  String get difficulty => translate('difficulty');
  String get players => translate('players');
  String get player => translate('player');
  String get points => translate('points');
  String get time => translate('time');
  String get lives => translate('lives');
  String get level => translate('level');
  String get rank => translate('rank');
  String get leaderboard => translate('leaderboard');
  String get achievements => translate('achievements');
  String get profile => translate('profile');
  String get login => translate('login');
  String get logout => translate('logout');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get username => translate('username');
  String get friends => translate('friends');
  String get invite => translate('invite');
  String get playAgain => translate('play_again');
  String get gameOver => translate('game_over');
  String get totalScore => translate('total_score');
  String get correctAnswers => translate('correct_answers');
  String get wrongAnswers => translate('wrong_answers');
  String get accuracy => translate('accuracy');
  String get host => translate('host');
  String get joinGame => translate('join_game');
  String get createGame => translate('create_game');
  String get roomCode => translate('room_code');
  String get waitingForPlayers => translate('waiting_for_players');
  String get tapToPlay => translate('tap_to_play');
  String get chooseAnswer => translate('choose_answer');
  String get powerUps => translate('power_ups');
  String get hint => translate('hint');
  String get skip => translate('skip');
  String get doublePoints => translate('double_points');
  String get fiftyFifty => translate('fifty_fifty');
  String get streak => translate('streak');
  String get combo => translate('combo');
  String get bonus => translate('bonus');
  String get rewards => translate('rewards');
  String get dailyReward => translate('daily_reward');
  String get streakBonus => translate('streak_bonus');
  String get sound => translate('sound');
  String get music => translate('music');
  String get vibrations => translate('vibrations');
  String get notifications => translate('notifications');
  String get privacyPolicy => translate('privacy_policy');
  String get termsOfService => translate('terms_of_service');
  String get contactUs => translate('contact_us');
  String get reportBug => translate('report_bug');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');
  String get version => translate('version');
  String get noInternet => translate('no_internet');
  String get connectionLost => translate('connection_lost');
  String get reconnecting => translate('reconnecting');
  String get updateAvailable => translate('update_available');
  String get newFeature => translate('new_feature');
  String get tutorial => translate('tutorial');
  String get howToPlay => translate('how_to_play');
  String get rules => translate('rules');
  String get goodLuck => translate('good_luck');
  String get congratulations => translate('congratulations');
  String get tryAgain => translate('try_again');
  String get youWon => translate('you_won');
  String get youLost => translate('you_lost');
  String get draw => translate('draw');
  String get finalResults => translate('final_results');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get all => translate('all');
  String get online => translate('online');
  String get offline => translate('offline');
  String get busy => translate('busy');
  String get away => translate('away');
  String get typing => translate('typing');
  String get send => translate('send');
  String get message => translate('message');
  String get chat => translate('chat');
  String get emoji => translate('emoji');
  String get mute => translate('mute');
  String get unmute => translate('unmute');
  String get video => translate('video');
  String get audio => translate('audio');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get photo => translate('photo');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get copy => translate('copy');
  String get paste => translate('paste');
  String get selectAll => translate('select_all');
  String get deselectAll => translate('deselect_all');
  String get undo => translate('undo');
  String get redo => translate('redo');
  String get refresh => translate('refresh');
  String get home => translate('home');
  String get menu => translate('menu');
  String get more => translate('more');
  String get less => translate('less');
  String get close => translate('close');
  String get open => translate('open');
  String get enable => translate('enable');
  String get disable => translate('disable');
  String get on => translate('on');
  String get off => translate('off');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get info => translate('info');
  String get warning => translate('warning');
  String get success => translate('success');
  String get failed => translate('failed');
  String get pending => translate('pending');
  String get completed => translate('completed');
  String get inProgress => translate('in_progress');
  String get disconnected => translate('disconnected');
  String get connecting => translate('connecting');
  String get connected => translate('connected');
  String get join => translate('join');
  String get leave => translate('leave');
  String get kick => translate('kick');
  String get ban => translate('ban');
  String get report => translate('report');
  String get block => translate('block');
  String get unblock => translate('unblock');
  String get follow => translate('follow');
  String get unfollow => translate('unfollow');
  String get subscribe => translate('subscribe');
  String get unsubscribe => translate('unsubscribe');
  String get like => translate('like');
  String get unlike => translate('unlike');
  String get comment => translate('comment');
  String get share => translate('share');
  String get download => translate('download');
  String get upload => translate('upload');
  String get install => translate('install');
  String get uninstall => translate('uninstall');
  String get update => translate('update');
  String get upgrade => translate('upgrade');
  String get purchase => translate('purchase');
  String get buy => translate('buy');
  String get sell => translate('sell');
  String get trade => translate('trade');
  String get coin => translate('coin');
  String get gem => translate('gem');
  String get ticket => translate('ticket');
  String get xpValue => translate('xp');
  String get rankUp => translate('rank_up');
  String get levelUp => translate('level_up');
  String get achievementUnlocked => translate('achievement_unlocked');
  String get newHighScore => translate('new_high_score');
  String get challenge => translate('challenge');
  String get tournament => translate('tournament');
  String get match => translate('match');
  String get season => translate('season');
  String get event => translate('event');
  String get special => translate('special');
  String get limitedTime => translate('limited_time');
  String get countdown => translate('countdown');
  String get ready => translate('ready');
  String get set => translate('set');
  String get go => translate('go');
  String get pause => translate('pause');
  String get resume => translate('resume');
  String get stop => translate('stop');
  String get finish => translate('finish');
  String get restart => translate('restart');
  String get quit => translate('quit');
  String get forfeit => translate('forfeit');
  String get tie => translate('tie');
  String get rematch => translate('rematch');
  String get spectator => translate('spectator');
  String get mode => translate('mode');
  String get classic => translate('classic');
  String get speed => translate('speed');
  String get survival => translate('survival');
  String get team => translate('team');
  String get solo => translate('solo');
  String get multiplayer => translate('multiplayer');
  String get singlePlayer => translate('single_player');
  String get ai => translate('ai');
  String get bot => translate('bot');
  String get easy => translate('easy');
  String get medium => translate('medium');
  String get hard => translate('hard');
  String get expert => translate('expert');
  String get nightMode => translate('night_mode');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get autoMode => translate('auto_mode');
  String get textSize => translate('text_size');
  String get small => translate('small');
  String get large => translate('large');
  String get defaultLabel => translate('default');
  String get custom => translate('custom');
  String get reset => translate('reset');
  String get apply => translate('apply');
  String get continueLabel => translate('continue');
  String get registerLabel => translate('register');
  String get newGame => translate('new_game');
  String get exitGame => translate('exit_game');
  String get backToMenu => translate('back_to_menu');
  String get backToGame => translate('back_to_game');
  String get enterRoomCode => translate('enter_room_code');
  String get enterName => translate('enter_name');
  String get enterEmail => translate('enter_email');
  String get enterPassword => translate('enter_password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get resetPassword => translate('reset_password');
  String get createAccount => translate('create_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get dontHaveAccount => translate('dont_have_account');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get guestMode => translate('guest_mode');
  String get linkAccount => translate('link_account');
  String get unlinkAccount => translate('unlink_account');
  String get accountSettings => translate('account_settings');
  String get changePassword => translate('change_password');
  String get changeEmail => translate('change_email');
  String get deleteAccount => translate('delete_account');
  String get areYouSure => translate('are_you_sure');
  String get thisCannotBeUndone => translate('this_cannot_be_undone');
  String get yesDelete => translate('yes_delete');
  String get keepPlaying => translate('keep_playing');
  String get noThanks => translate('no_thanks');
  String get remindLater => translate('remind_later');
  String get dismiss => translate('dismiss');
  String get gotIt => translate('got_it');
  String get learnMore => translate('learn_more');
  String get showMore => translate('show_more');
  String get showLess => translate('show_less');
  String get tapHere => translate('tap_here');
  String get swipeToContinue => translate('swipe_to_continue');
  String get slideToConfirm => translate('slide_to_confirm');
  String get pullToRefresh => translate('pull_to_refresh');
  String get doubleTap => translate('double_tap');
  String get longPress => translate('long_press');
  String get dragAndDrop => translate('drag_and_drop');
  String get pinchToZoom => translate('pinch_to_zoom');
  String get rotate => translate('rotate');
  String get flip => translate('flip');
  String get shuffle => translate('shuffle');
  String get deal => translate('deal');
  String get spin => translate('spin');
  String get roll => translate('roll');
  String get guess => translate('guess');
  String get reveal => translate('reveal');
  String get hide => translate('hide');
  String get show => translate('show');
  String get lock => translate('lock');
  String get unlock => translate('unlock');
  String get enableNotifications => translate('enable_notifications');
  String get allowMicrophone => translate('allow_microphone');
  String get allowCamera => translate('allow_camera');
  String get allowStorage => translate('allow_storage');
  String get allowLocation => translate('allow_location');
  String get permissionDenied => translate('permission_denied');
  String get permissionGranted => translate('permission_granted');
  String get alwaysAllow => translate('always_allow');
  String get whileUsing => translate('while_using');
  String get deny => translate('deny');
  String get grant => translate('grant');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLocalizations &&
          runtimeType == other.runtimeType &&
          localeCode == other.localeCode;

  @override
  int get hashCode => localeCode.hashCode;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      XoLocale.supportedLocales.any((l) => l.code == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      Future.value(AppLocalizations(locale.languageCode));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => other is AppLocalizationsDelegate;
}
