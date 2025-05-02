import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/app_export.dart';
import 'package:get/get.dart';

class timelineScreen extends StatelessWidget {
  final List<TimelineStep> steps = const [
    TimelineStep("Receiving the emergency call", true),
    TimelineStep("Dispatching emergency resources", true),
    TimelineStep("Help is on the way", true),
    TimelineStep("Arrival at the scene", false),
    TimelineStep("Care completed", false),
  ];

  const timelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appTheme.indigo50,
        body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 30, top: 56, right: 30),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  "You're not alone \n — help is coming",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: 30),
                _buildColumnassignedt(context),
                SizedBox(height: 30),
                _buildRowclockone(context),
                SizedBox(height: 60),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:_buildTimeline(context),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4, right: 14),
                  height: 24,
                  width: double.maxFinite,
                )
              ],
            ),
        ),
    );
  }


  /// Section Widget
  Widget _buildColumnassignedt(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 4, right: 2),
      padding: EdgeInsets.symmetric(vertical: 32),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Assigned Team: \nMobile Healthcare teams",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  /// Section Widget
Widget _buildRowclockone(BuildContext context){
    return Container(
      margin: EdgeInsets.only(left: 4),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 30),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          Image.asset(
            ImageConstant.imgClock,
            height: 34,
            width: 34,
            fit: BoxFit.contain,
          ),
          SizedBox(width:18),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estimated arrival: 10-15 min",
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "(Update 2 min ago)",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
          ),
        ],
      ),
    );
}


///Timeline section
  Widget _buildTimeline(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dot + Line
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: step.isActive ? Colors.black : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: step.isActive? Colors.black: appTheme.gray600,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  step.title,
                  style: TextStyle(
                    color: step.isActive ? Colors.black : appTheme.gray600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class TimelineStep {
  final String title;
  final bool isActive;
  const TimelineStep(this.title, this.isActive);
}


