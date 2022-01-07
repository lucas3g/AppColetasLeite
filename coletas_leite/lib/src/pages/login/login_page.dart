import 'package:coletas_leite/src/pages/login/widgets/login_input_button_widget.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.colors.backgroundPrimary,
        title: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Coletas', style: AppTheme.textStyles.titleLogin),
                Text(
                  ' Plus',
                  style: AppTheme.textStyles.titleLogin.copyWith(
                    color: Color(0xFF525252),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.colors.backgroundPrimary,
      body: LoginInputButtonWidget(),
    );
  }
}
