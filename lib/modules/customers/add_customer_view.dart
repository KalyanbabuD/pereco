import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  Widget _buildTextField({
    required String label,
    required TextEditingController textController,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    RxnString? errorText,
  }) {
    Widget buildField(String? error) {
      return TextField(
        controller: textController,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black54, size: 20) : null,
          errorText: error,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      );
    }

    if (errorText != null) {
      return Obx(() => buildField(errorText.value));
    }
    return buildField(null);
  }

  Widget _buildResponsiveRow(BuildContext context, List<Widget> fields) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return Column(
        children: fields.map((f) => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: f)).toList(),
      );
    } else {
      List<Widget> rowChildren = [];
      for (int i = 0; i < fields.length; i++) {
        rowChildren.add(Expanded(child: fields[i]));
        if (i < fields.length - 1) {
          rowChildren.add(const SizedBox(width: 16));
        }
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(children: rowChildren),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F8),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Customer', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 4),
                      Text('Fill out the form to add a new customer', style: TextStyle(color: Colors.black87, fontSize: 13)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            
            // TabBar
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.orange,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Info'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 18),
                        SizedBox(width: 8),
                        Flexible(child: Text('Billing &\nShipping Address', overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // Info Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResponsiveRow(context, [
                          _buildTextField(label: 'Company', textController: controller.companyController, prefixIcon: Icons.domain, errorText: controller.companyError),
                          _buildTextField(label: 'Website', textController: controller.websiteController, prefixIcon: Icons.language),
                        ]),
                        _buildResponsiveRow(context, [
                          _buildTextField(label: 'State', textController: controller.stateController, prefixIcon: Icons.map_outlined),
                          _buildTextField(label: 'City', textController: controller.cityController, prefixIcon: Icons.location_city),
                          _buildTextField(label: 'Zip Code', textController: controller.zipController, prefixIcon: Icons.pin_drop_outlined),
                        ]),
                        _buildTextField(label: 'Address', textController: controller.addressController, maxLines: 3),
                        const SizedBox(height: 24),
                        const Text('Contact Person', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildResponsiveRow(context, [
                          _buildTextField(label: 'First Name', textController: controller.firstNameController, prefixIcon: Icons.person),
                          _buildTextField(label: 'Last Name', textController: controller.lastNameController, prefixIcon: Icons.person),
                          _buildTextField(label: 'Phone Number', textController: controller.phoneController, prefixIcon: Icons.phone, keyboardType: TextInputType.phone),
                        ]),
                        _buildResponsiveRow(context, [
                          _buildTextField(label: 'Title', textController: controller.titleController, prefixIcon: Icons.badge_outlined),
                          _buildTextField(label: 'Email', textController: controller.emailController, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        ]),
                      ],
                    ),
                  ),
                  
                  // Billing & Shipping Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Billing Address', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildResponsiveRow(context, [
                          _buildTextField(label: 'Street', textController: controller.billingStreetController, prefixIcon: Icons.signpost_outlined),
                          _buildTextField(label: 'City', textController: controller.billingCityController, prefixIcon: Icons.location_city),
                          _buildTextField(label: 'State', textController: controller.billingStateController, prefixIcon: Icons.map_outlined),
                        ]),
                        SizedBox(
                          width: MediaQuery.of(context).size.width < 600 ? double.infinity : (MediaQuery.of(context).size.width / 3 - 24),
                          child: _buildTextField(label: 'Zip Code', textController: controller.billingZipController, prefixIcon: Icons.pin_drop_outlined),
                        ),
                        const SizedBox(height: 24),
                        Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.sameAsBilling.value,
                              onChanged: (val) => controller.sameAsBilling.value = val ?? false,
                              activeColor: Colors.blue,
                            ),
                            const Text('Shipping address is same as Billing address', style: TextStyle(color: Colors.red)),
                          ],
                        )),
                        const SizedBox(height: 24),
                        const Text('Shipping Address', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Obx(() => _buildResponsiveRow(context, [
                          IgnorePointer(
                            ignoring: controller.sameAsBilling.value,
                            child: Opacity(
                              opacity: controller.sameAsBilling.value ? 0.5 : 1.0,
                              child: _buildTextField(label: 'Street', textController: controller.shippingStreetController, prefixIcon: Icons.signpost_outlined),
                            ),
                          ),
                          IgnorePointer(
                            ignoring: controller.sameAsBilling.value,
                            child: Opacity(
                              opacity: controller.sameAsBilling.value ? 0.5 : 1.0,
                              child: _buildTextField(label: 'City', textController: controller.shippingCityController, prefixIcon: Icons.location_city),
                            ),
                          ),
                          IgnorePointer(
                            ignoring: controller.sameAsBilling.value,
                            child: Opacity(
                              opacity: controller.sameAsBilling.value ? 0.5 : 1.0,
                              child: _buildTextField(label: 'State', textController: controller.shippingStateController, prefixIcon: Icons.map_outlined),
                            ),
                          ),
                        ])),
                        Obx(() => SizedBox(
                          width: MediaQuery.of(context).size.width < 600 ? double.infinity : (MediaQuery.of(context).size.width / 3 - 24),
                          child: IgnorePointer(
                            ignoring: controller.sameAsBilling.value,
                            child: Opacity(
                              opacity: controller.sameAsBilling.value ? 0.5 : 1.0,
                              child: _buildTextField(label: 'Zip Code', textController: controller.shippingZipController, prefixIcon: Icons.pin_drop_outlined),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer Buttons
            Builder(
              builder: (BuildContext context) {
                final TabController tabController = DefaultTabController.of(context);
                return AnimatedBuilder(
                  animation: tabController,
                  builder: (context, _) {
                    bool isInfoTab = tabController.index == 0;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: isInfoTab 
                          ? [
                              ElevatedButton(
                                onPressed: () {
                                  tabController.animateTo(1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cardDarkBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ]
                          : [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 16),
                              Obx(() => ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.submitCustomer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cardDarkBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              )),
                            ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
