import 'package:flutter/material.dart';
import '../../domain/entities.dart';

class ShippingAddressForm extends StatefulWidget {
  final Function(Address shipping, Address billing) onSubmit;

  const ShippingAddressForm({super.key, required this.onSubmit});

  @override
  State<ShippingAddressForm> createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<ShippingAddressForm> {
  final _formKey = GlobalKey<FormState>();
  bool _sameAsBilling = true;

  // Form values for shipping address
  String _shippingStreet = '';
  String _shippingCity = '';
  String _shippingState = '';
  String _shippingCountry = '';
  String _shippingZipCode = '';

  // Form values for billing address
  String _billingStreet = '';
  String _billingCity = '';
  String _billingState = '';
  String _billingCountry = '';
  String _billingZipCode = '';

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final shippingAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        street: _shippingStreet,
        city: _shippingCity,
        state: _shippingState,
        country: _shippingCountry,
        postalCode: _shippingZipCode,
      );

      final billingAddress =
          _sameAsBilling
              ? shippingAddress
              : Address(
                id: '${DateTime.now().millisecondsSinceEpoch}_billing',
                street: _billingStreet,
                city: _billingCity,
                state: _billingState,
                country: _billingCountry,
                postalCode: _billingZipCode,
              );

      widget.onSubmit(shippingAddress, billingAddress);
    }
  }

  Widget _buildAddressFields({
    required String Function(String?) onStreetSaved,
    required String Function(String?) onCitySaved,
    required String Function(String?) onStateSaved,
    required String Function(String?) onCountrySaved,
    required String Function(String?) onZipCodeSaved,
  }) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Street'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: onStreetSaved,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'City'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: onCitySaved,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: onStateSaved,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'ZIP Code'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onSaved: onZipCodeSaved,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Country'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          onSaved: onCountrySaved,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipping Address')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAddressFields(
              onStreetSaved: (value) => _shippingStreet = value ?? '',
              onCitySaved: (value) => _shippingCity = value ?? '',
              onStateSaved: (value) => _shippingState = value ?? '',
              onCountrySaved: (value) => _shippingCountry = value ?? '',
              onZipCodeSaved: (value) => _shippingZipCode = value ?? '',
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _sameAsBilling,
              onChanged: (value) => setState(() => _sameAsBilling = value!),
              title: const Text('Billing address same as shipping'),
            ),
            if (!_sameAsBilling) ...[
              const SizedBox(height: 16),
              const Text(
                'Billing Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAddressFields(
                onStreetSaved: (value) => _billingStreet = value ?? '',
                onCitySaved: (value) => _billingCity = value ?? '',
                onStateSaved: (value) => _billingState = value ?? '',
                onCountrySaved: (value) => _billingCountry = value ?? '',
                onZipCodeSaved: (value) => _billingZipCode = value ?? '',
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Continue to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
