import 'package:aoun/core/di/injection_container.dart';
import 'package:aoun/core/routing/app_routes.dart';
import 'package:aoun/core/storage/auth_local_data_source.dart';
import 'package:aoun/features/auth/log_in/data/datasources/social_auth_remote_data_source.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/social_auth_cubit.dart';
import 'package:aoun/features/auth/log_in/presentation/cubit/social_auth_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialAuthCubit>(
      create: (_) {
        // Fallback registration to prevent GetIt reassemble crashes on Hot Reload
        if (!sl.isRegistered<SocialAuthCubit>()) {
          if (!sl.isRegistered<SocialAuthRemoteDataSource>()) {
            sl.registerLazySingleton<SocialAuthRemoteDataSource>(
              () => SocialAuthRemoteDataSourceImpl(sl<Dio>()),
            );
          }
          sl.registerFactory<SocialAuthCubit>(
            () => SocialAuthCubit(
              remoteDataSource: sl<SocialAuthRemoteDataSource>(),
              localDataSource: sl<AuthLocalDataSource>(),
            ),
          );
        }
        return sl<SocialAuthCubit>();
      },
      child: const _SocialButtonsContent(),
    );
  }
}

class _SocialButtonsContent extends StatelessWidget {
  const _SocialButtonsContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAuthCubit, SocialAuthState>(
      listener: (context, state) {
        if (state is SocialAuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(state.authResponse.message ?? 'Login successful!'),
                ],
              ),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushReplacementNamed(AppRoutes.mainhome);
        } else if (state is SocialAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.white),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SocialAuthCubit>();
        final isGoogleLoading =
            state is SocialAuthLoading && state.provider == 'google';
        final isFbLoading =
            state is SocialAuthLoading && state.provider == 'facebook';

        return Column(
          children: [
            // Divider with text
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
              ],
            ),
            SizedBox(height: 16.h),

            // Social buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                  background: const Color(0xFFDB4437),
                  isLoading: isGoogleLoading,
                  onTap: () => cubit.loginWithGoogle(),
                ),
                SizedBox(width: 14.w),
                _SocialButton(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  background: const Color(0xFF1877F2),
                  isLoading: isFbLoading,
                  onTap: () => cubit.loginWithFacebook(),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Info text about browser redirect
            Text(
              'You will be redirected to your browser to sign in',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final bool isLoading;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50.h,
        width: 130.w,
        decoration: BoxDecoration(
          color: isLoading ? background.withOpacity(0.5) : background,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: background.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 16.r),
                  SizedBox(width: 8.w),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
