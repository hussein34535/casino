enum PowerUpType {
  doublePoints,
  skipQuestion,
  freezeTime,
  revealAnswer,
  shield,
  stealPoints,
  sabotage,
  fiftyFifty,
  timeBonus,
  multiplier,
}

class PowerUp {
  final PowerUpType type;
  int quantity;

  PowerUp({required this.type, this.quantity = 0});

  String get name {
    switch (type) {
      case PowerUpType.doublePoints: return 'نقاط مضاعفة';
      case PowerUpType.skipQuestion: return 'تخطي السؤال';
      case PowerUpType.freezeTime: return 'تجميد الوقت';
      case PowerUpType.revealAnswer: return 'كشف الإجابة';
      case PowerUpType.shield: return 'درع حماية';
      case PowerUpType.stealPoints: return 'سرقة النقاط';
      case PowerUpType.sabotage: return 'تخريب الخصم';
      case PowerUpType.fiftyFifty: return 'خمسين خمسين';
      case PowerUpType.timeBonus: return 'مكافأة الوقت';
      case PowerUpType.multiplier: return 'مضاعف x3';
    }
  }

  String get icon {
    switch (type) {
      case PowerUpType.doublePoints: return 'x2';
      case PowerUpType.skipQuestion: return '⏭️';
      case PowerUpType.freezeTime: return '❄️';
      case PowerUpType.revealAnswer: return '👁️';
      case PowerUpType.shield: return '🛡️';
      case PowerUpType.stealPoints: return '🦹';
      case PowerUpType.sabotage: return '💣';
      case PowerUpType.fiftyFifty: return '50/50';
      case PowerUpType.timeBonus: return '⏰';
      case PowerUpType.multiplier: return 'x3';
    }
  }
}
