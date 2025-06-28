import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:chat_app_ex/core/router/router.dart';
import 'package:chat_app_ex/core/widgets/chat_textfiled.dart';
import 'package:chat_app_ex/features/login/data/models/country_model.dart';
import 'package:chat_app_ex/features/login/data/services/country_service.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final CountryService _countryService = CountryService();
  List<Country> countries = <Country>[];
  Country? selectedCountry;
  bool isLoadingCountries = true;
  String? countryError;

  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      setState(() {
        isLoadingCountries = true;
        countryError = null;
      });

      final List<Country> fetchedCountries = await _countryService
          .getCountries();

      fetchedCountries.sort((Country a, Country b) => a.name.compareTo(b.name));

      setState(() {
        countries = fetchedCountries;

        if (countries.isNotEmpty) {
          try {
            selectedCountry = countries.firstWhere(
              (Country country) => country.name == 'United States',
            );
          } catch (_) {
            selectedCountry = countries.first;
          }
        }
        isLoadingCountries = false;
      });
    } catch (e) {
      setState(() {
        countryError = 'Failed to load countries: $e';
        isLoadingCountries = false;
      });
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }
    final String email = _formKey.currentState!.fields['email']!.value.trim();
    final String password = _formKey.currentState!.fields['password']!.value
        .trim();
    final String name = _formKey.currentState!.fields['full_name']!.value
        .trim();
    final String mobile = _formKey.currentState!.fields['mobile_number']!.value
        .trim();
    final Country? selectedCountry = this.selectedCountry;
    if (selectedCountry == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.locale.selectCountry)));
      return;
    }

    context.read<AuthCubit>().signUp(
      email: email,
      password: password,
      name: name,
      mobile: mobile,
      country: selectedCountry.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

      body: BlocListener<AuthCubit, AuthState>(
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
        child: FormBuilder(
          key: _formKey,
          child: ScreenTypeLayout.builder(
            mobile: (BuildContext context) {
              return _buildMobileLayout(
                context,
                context.watch<AuthCubit>().state,
                isLandscape,
              );
            },
            tablet: (BuildContext context) {
              return _buildTabletLayout(
                context,
                context.watch<AuthCubit>().state,
                isLandscape,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AuthState state,
    bool isLandscape,
  ) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isLandscape ? 800 : 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: isLandscape
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: _buildHeader()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildForm(),
                            const SizedBox(height: 16),
                            _buildAction(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildHeader(),
                      _buildForm(),
                      const SizedBox(height: 16),
                      _buildAction(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AuthState state,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: _buildHeader()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildForm(),
                    const SizedBox(height: 16),
                    _buildAction(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          Expanded(child: SingleChildScrollView(child: _buildForm())),
          _buildAction(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAction() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        final bool isLoading = state.isLoading;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: isLoading ? null : _signup,
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
                        context.locale.createAccount,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: context.locale.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${context.locale.signIn}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
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
                Icons.person_add_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.locale.createAccount,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.locale.createAccountDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ChatTextField(
          hintText: context.locale.fullName,
          textFieldName: 'full_name',
          autoValidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.words,
          prefixIcon: Icon(
            Icons.person_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          validators: <FormFieldValidator<String>>[
            FormBuilderValidators.required(
              errorText: context.locale.fullNameRequired,
            ),
          ],
        ),

        ChatTextField(
          autoValidateMode: AutovalidateMode.onUserInteraction,
          hintText: context.locale.email,
          textFieldName: 'email',
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.fromBorderSide(
              BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.12),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isLoadingCountries
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              : countryError != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Failed to load countries',
                          style: TextStyle(
                            color: Colors.red.shade300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _fetchCountries,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : DropdownButtonFormField<Country>(
                  value: selectedCountry,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: countries.map((Country country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              country.flagUrl,
                              width: 24,
                              height: 16,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return const Icon(Icons.flag, size: 24);
                                  },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              country.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Country? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCountry = newValue;
                      });
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                ),
        ),

        ChatTextField(
          hintText: context.locale.mobileNumber,
          textFieldName: 'mobile_number',
          autoValidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ),
        ChatTextField(
          hintText: context.locale.password,
          textFieldName: 'password',
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validators: <FormFieldValidator<String?>>[
            FormBuilderValidators.required(
              errorText: context.locale.passwordRequired,
            ),
            FormBuilderValidators.minLength(
              6,
              errorText: context.locale.passwordMinLength,
            ),
          ],
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          obscureText: !_passwordVisible,
          maxLines: 1,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            child: Icon(_passwordVisible ? Icons.lock : Icons.lock_open),
          ),
        ),

        ChatTextField(
          hintText: context.locale.confirmPassword,
          textFieldName: 'confirm_password',

          autoValidateMode: AutovalidateMode.onUserInteraction,
          validators: <FormFieldValidator<String?>>[
            FormBuilderValidators.required(
              errorText: context.locale.passwordRequired,
            ),
            FormBuilderValidators.minLength(
              6,
              errorText: context.locale.passwordMinLength,
            ),

            (String? val) {
              if (val != _formKey.currentState?.getRawValue('password')) {
                return context.locale.passwordsDoNotMatch;
              }
              return null;
            },
          ],
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          obscureText: !_confirmPasswordVisible,
          maxLines: 1,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
            child: Icon(_confirmPasswordVisible ? Icons.lock : Icons.lock_open),
          ),
        ),
      ],
    );
  }
}
