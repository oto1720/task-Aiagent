import 'package:flutter/material.dart';
import 'package:task_aiagent/core/constant/themes.dart';

/// 動的な挨拶ヘッダーウィジェット
///
/// 時間帯に応じた挨拶とAIからの日替わりヒントを表示
class GreetingHeader extends StatelessWidget {
  final String userName;
  final String? aiHint;

  const GreetingHeader({
    super.key,
    this.userName = '田中',
    this.aiHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppThemes.primaryBlue.withValues(alpha: 0.1),
            AppThemes.lightBlue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemes.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 挨拶部分
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemes.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTimeIcon(),
                  size: 28,
                  color: AppThemes.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(userName),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // AIヒント部分
          if (aiHint != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppThemes.lightBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates_outlined,
                    size: 20,
                    color: AppThemes.darkBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      aiHint!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppThemes.secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 時間帯に応じた挨拶を取得
  String _getGreeting(String name) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'おはよう、${name}さん！';
    } else if (hour >= 11 && hour < 17) {
      return 'こんにちは、${name}さん！';
    } else if (hour >= 17 && hour < 22) {
      return 'こんばんは、${name}さん！';
    } else {
      return '夜更かし中ですか、${name}さん！';
    }
  }

  /// 時間帯に応じたアイコンを取得
  IconData _getTimeIcon() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return Icons.wb_sunny_outlined;
    } else if (hour >= 11 && hour < 17) {
      return Icons.wb_sunny;
    } else if (hour >= 17 && hour < 22) {
      return Icons.nights_stay_outlined;
    } else {
      return Icons.bedtime_outlined;
    }
  }
}
