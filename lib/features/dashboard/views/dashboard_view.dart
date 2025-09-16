import 'package:flutter/material.dart';
import 'package:parkaways_ep_flutter/features/dashboard/controllers/dashboard_controllers.dart';
import 'package:parkaways_ep_flutter/features/dashboard/models/dashboard_models.dart';
import 'proses.dart'; // Import ProsesView
import 'waktu.dart'; // Import WaktuView
import 'bayar.dart'; // Import BayarView

class DashboardView extends StatelessWidget {
  final DashboardModel model = DashboardModel();
  final DashboardController controller = DashboardController();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _buildAppBarContent(context),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBarContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  model.appBarTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  _buildLostTicketButton(context),
                  const SizedBox(width: 16),
                  _buildSettingsButton(context),
                ],
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  model.appBarTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.receipt, color: Colors.white),
                    onPressed: () => controller.handleLostTicket(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => controller.handleSettings(context),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildLostTicketButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.handleLostTicket(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt, size: 18),
          const SizedBox(width: 8),
          Text(
            model.lostTicketText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.handleSettings(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.settings, size: 18),
          const SizedBox(width: 8),
          Text(
            model.settingsText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF001F3F),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:0),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive layout untuk tablet
                  if (constraints.maxWidth > 900) {
                    // Layout 3 kolom untuk layar besar - PROSES & WAKTU SEJAJAR
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Kolom Proses dan Waktu (Kiri) - 70%
                        Expanded(
                          flex: 5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Proses - 60%
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF001F3F),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProsesView(controller: controller),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 0),
                              // Waktu - 40%
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     blurRadius: 8,
                                    //     offset: const Offset(0, 2),
                                    //   ),
                                    // ],
                                  ),
                                  child: const WaktuView(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Kolom Bayar (Kanan) - 30%
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   // BoxShadow(
                              //   //   color: Colors.black.withOpacity(0.1),
                              //   //   blurRadius: 8,
                              //   //   offset: const Offset(0, 2),
                              //   // ),
                              // ],
                            ),
                            child: const BayarView(),
                          ),
                        ),
                      ],
                    );
                  } else if (constraints.maxWidth > 600) {
                    // Layout 2 kolom untuk tablet medium - PROSES & WAKTU SEJAJAR
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Kolom Proses dan Waktu (Kiri) - 70%
                        Expanded(
                          flex: 7,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Proses - 60%
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF001F3F),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProsesView(controller: controller),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Waktu - 40%
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     blurRadius: 8,
                                    //     offset: const Offset(0, 2),
                                    //   ),
                                    // ],
                                  ),
                                  child: const WaktuView(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Kolom Bayar (Kanan) - 30%
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.1),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 2),
                              //   ),
                              // ],
                            ),
                            child: const BayarView(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Layout 1 kolom untuk mobile - TETAP VERTICAL
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Proses
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF001F3F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProsesView(controller: controller),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Waktu
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   // BoxShadow(
                              //   //   color: Colors.black.withOpacity(0.1),
                              //   //   blurRadius: 8,
                              //   //   offset: const Offset(0, 2),
                              //   // ),
                              // ],
                            ),
                            child: const WaktuView(),
                          ),
                          const SizedBox(height: 16),
                          // Bayar
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.1),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 2),
                              //   ),
                              // ],
                            ),
                            child: const BayarView(),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}