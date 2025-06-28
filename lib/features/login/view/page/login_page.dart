import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:chat_app_ex/core/router/router.dart';
import 'package:chat_app_ex/core/widgets/chat_textfiled.dart';
import 'package:chat_app_ex/features/home/view/widgets/profile_widget.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _passwordVisible = true;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final String email = _formKey.currentState!.fields['email']!.value.trim();
    final String password = _formKey.currentState!.fields['password']!.value
        .trim();
    TextInput.finishAutofillContext();
    context.read<AuthCubit>().login(email, password);
  }

  Widget _buildLoginHeader() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    Theme.of(context).colorScheme.primary,
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.chat_bubble_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              context.locale.welcomeBack,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.locale.signInToContinue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return AutofillGroup(
      child: Column(
        children: <Widget>[
          ChatTextField(
            autofillHints: const <String>[AutofillHints.email],
            hintText: context.locale.email,
            textFieldName: 'email',
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validators: <FormFieldValidator<String>>[
              FormBuilderValidators.required(
                errorText: context.locale.emailRequired,
              ),
              FormBuilderValidators.email(
                errorText: context.locale.invalidEmail,
              ),
            ],
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20.sp,
            ),
          ),
          const SizedBox(height: 16),

          ChatTextField(
            autofillHints: const <String>[AutofillHints.password],
            maxLines: 1,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            textFieldName: 'password',
            hintText: context.locale.password,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              child: Icon(_passwordVisible ? Icons.lock : Icons.lock_open),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              size: 20.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            validators: <FormFieldValidator<String>>[
              FormBuilderValidators.required(
                errorText: context.locale.passwordRequired,
              ),
              FormBuilderValidators.minLength(
                6,
                errorText: context.locale.passwordMinLength,
              ),
            ],
            obscureText: _passwordVisible,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AuthState state) {
    final bool isLoading = state.isLoading;
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(14),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    context.locale.login,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          TextButton(
            onPressed: () {
              const SignupRoute().push(context);
            },
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: context.locale.dontHaveAccount,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                  TextSpan(
                    text: ' ${context.locale.signUp}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LanguageSwitcherWidget()],
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state.userCredential != null) {
            const HomeRoute().go(context);
          } else if (state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (BuildContext context, AuthState state) {
          final bool isLandscape =
              MediaQuery.orientationOf(context) == Orientation.landscape;
          return ScreenTypeLayout.builder(
            mobile: (BuildContext context) {
              return _buildMobileLayout(context, state, isLandscape);
            },
            tablet: (BuildContext context) {
              return _buildTabletLayout(context, state, isLandscape);
            },
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AuthState state,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return FormBuilder(
        key: _formKey,
        child: Row(
          children: <Widget>[
            Expanded(child: Center(child: _buildLoginHeader())),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLoginForm(),
                      const SizedBox(height: 16),
                      _buildActionButtons(state),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[_buildLoginHeader(), _buildLoginForm()],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildActionButtons(state),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AuthState state,
    bool isLandscape,
  ) {
    return FormBuilder(
      key: _formKey,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isLandscape ? 800 : 600,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: isLandscape
              ? Row(
                  children: <Widget>[
                    Expanded(flex: 2, child: _buildLoginHeader()),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _buildLoginForm(),
                              const SizedBox(height: 16),
                              _buildActionButtons(state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLoginHeader(),
                      _buildLoginForm(),
                      const SizedBox(height: 40),
                      _buildActionButtons(state),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
