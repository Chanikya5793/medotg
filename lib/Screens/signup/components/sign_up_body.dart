import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:medotg/controller/flow_controller.dart';

import 'flow_one.dart';
import 'flow_three.dart';
import 'flow_two.dart';

class SignUpBodyScreen extends StatefulWidget {
  const SignUpBodyScreen({super.key});

  @override
  State<SignUpBodyScreen> createState() => _SignUpBodyScreenState();
}

class _SignUpBodyScreenState extends State<SignUpBodyScreen> {
  FlowController flowController = Get.put(FlowController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            // Image asset at the bottom of the stack
            Image.asset(
              'assets/Images/plants.png',
              scale: 10,
              fit: BoxFit.cover,
              width: 500,
              height: 500,
            ),
            // Content on top of the image
            ListView(
              padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
              shrinkWrap: true,
              reverse: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 535,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: GetBuilder<FlowController>(
                        builder: (context) {
                          // Displays the view according to the current flow
                          if (flowController.currentFlow == 1) {
                            return const SignUpOne();
                          } else if (flowController.currentFlow == 2) {
                            return const SignUpTwo();
                          } else {
                            return const SignUpThree();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
