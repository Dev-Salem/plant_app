import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';

class HandleError {
  static String getFriendlyErrorMessage(Exception exception) {
    debugPrint(exception.toString());
    final errorMessages = {
      'user_password_mismatch':
          'Passwords do not match. Please check the password and confirm password.',
      'password_recently_used':
          'The password you are trying to use is similar to your previous password. Please choose a different one.',
      'password_personal_data':
          'Your password contains personal data. Choose a more secure password.',
      'user_phone_not_found': 'No phone number is associated with your account.',
      'user_invalid_credentials': 'Invalid credentials. Please check your email and password.',
      'user_not_found': 'User not found. Please check your details and try again.',
      'user_session_already_exists': 'Session is already active, try again',
      'user_already_exists': 'An account with the same details already exists.',
      'user_email_already_exists': 'This email is already in use.',
      'user_phone_already_exists': 'This phone number is already in use.',
      'user_blocked': 'Your account has been blocked. Contact support for assistance.',
      'user_invalid_token': 'Invalid authentication token. Please log in again.',
      'user_unauthorized': 'You are not authorized to perform this action.',
      'user_password_reset_required': 'You need to reset your password before proceeding.',
      'user_count_exceeded': 'User limit exceeded. Contact support for more information.',
      'user_auth_method_unsupported': 'This authentication method is not supported.',
      'team_invite_mismatch': 'This invitation does not belong to your account.',
      'team_not_found': 'The requested team could not be found.',
      'membership_not_found': 'Membership not found.',

      // Collection related errors
      'collection_limit_exceeded':
          'Maximum collection limit reached. Please contact support for assistance.',
      'collection_not_found': 'The requested collection could not be found.',
      'collection_already_exists': 'A collection with this identifier already exists.',

      // Document related errors
      'document_invalid_structure':
          'The document format is invalid. Please check the required fields.',
      'document_missing_data': 'Required document information is missing.',
      'document_missing_payload': 'Required document information is incomplete.',
      'document_not_found': 'The requested document could not be found.',
      'document_already_exists': 'A document with this identifier already exists.',
      'document_update_conflict':
          'The document has been modified. Please refresh and try again.',
      'document_delete_restricted':
          'This document cannot be deleted as it is being used by other records.',

      // Attribute related errors
      'attribute_unknown': 'Invalid field in the request.',
      'attribute_not_available': 'This field is temporarily unavailable.',
      'attribute_format_unsupported': 'The provided format is not supported.',
      'attribute_default_unsupported': 'Default values cannot be set for this type of field.',
      'attribute_limit_exceeded': 'Maximum number of fields reached.',
      'attribute_value_invalid': 'Invalid field value provided.',
      'attribute_type_invalid': 'Invalid field type.',
      'attribute_not_found': 'The requested field could not be found.',
      'attribute_already_exists': 'A field with this identifier already exists.',

      // Index related errors
      'index_limit_exceeded': 'Maximum index limit reached.',
      'index_invalid': 'The index configuration is invalid.',
      'index_not_found': 'The requested index could not be found.',
      'index_already_exists': 'An index with this identifier already exists.',

      // Database related errors
      'database_not_found': 'The requested database could not be found.',
      'database_already_exists': 'A database with this name already exists.',

      // Build and deployment errors
      'build_not_ready': 'The requested build is still in progress.',
      'build_in_progress': 'A build is already in progress. Please wait.',
      'build_not_found': 'The requested build could not be found.',
      'deployment_not_found': 'The requested deployment could not be found.',

      // Function related errors
      'function_not_found': 'The requested function could not be found.',
      'function_runtime_unsupported': 'The requested runtime configuration is not supported.',

      // Installation and repository errors
      'installation_not_found': 'The requested installation could not be found.',
      'provider_repository_not_found': 'The requested repository could not be found.',
      'repository_not_found': 'The requested repository could not be found.',
      'provider_contribution_conflict': 'This contribution has already been authorized.',

      // Variable related errors
      'variable_not_found': 'The requested variable could not be found.',
      'variable_already_exists': 'A variable with this identifier already exists.',

      // Execution related errors
      'execution_not_found': 'The requested execution could not be found.',
      'rate_limit_exceeded':
          'Daily limit of 3 requests was exceeded. Please upgrade to Pro to enjoy using this feature or come tomorrow',
      'network_exception':
          'Network error. Please check your internet connection and try again.',
      'rate_time_limit_exceeded': 'Rate Time Limit. Please try again after a minute or two.',
    };

    if (exception is AppwriteException) {
      return errorMessages[exception.type] ?? 'Something went wrong';
    }

    return 'An unknown error occurred. Please contact support if this continues.';
  }
}
