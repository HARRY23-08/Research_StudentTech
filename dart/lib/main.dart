import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// -----------------------------------------------------------------
// DATA MODELS
// -----------------------------------------------------------------
class AppointmentItem {
  final String title;
  final String date;
  final String time;
  final String status;

  AppointmentItem({
    required this.title,
    required this.date,
    required this.time,
    required this.status,
  });
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String details;
  bool read;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.details,
    this.read = false,
  });
}

class AppData {
  static final List<AppointmentItem> appointments = [
    AppointmentItem(
      title: 'Enrollment Consultation',
      date: 'Feb 15, 2027',
      time: '9:00 AM',
      status: 'Confirmed',
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCC Queue System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// -----------------------------------------------------------------
// 0. LOGIN & REGISTRATION SCREEN
// -----------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'Cunananmcc@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;
  bool _isLoginMode = true;

  void _submitAuth() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, size: 54, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'MCC Queue System',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Registrar\'s Office Appointment & Queue Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isLoginMode ? 'Welcome Back' : 'Create Student Account',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isLoginMode
                              ? 'Sign in with your MCC student credentials'
                              : 'Register to book appointments & track your queue',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        if (!_isLoginMode) ...[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter your full name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Student ID (e.g. 2023-12345)',
                              prefixIcon: const Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter your Student ID' : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'MCC Email or Student ID',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email or student ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return 'Password must be at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        if (_isLoginMode)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Password reset link sent to your MCC email.')),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Color(0xFFB71C1C), fontSize: 13),
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB71C1C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _isLoginMode ? 'Log In' : 'Sign Up',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLoginMode ? "Don't have an account? " : "Already have an account? ",
                              style: const TextStyle(color: Colors.black54, fontSize: 13),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLoginMode = !_isLoginMode;
                                });
                              },
                              child: Text(
                                _isLoginMode ? 'Sign Up' : 'Log In',
                                style: const TextStyle(
                                  color: Color(0xFFB71C1C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// MAIN NAVIGATION WRAPPER
// -----------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateToTab: _switchTab),
      const AppointmentsScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
        selectedItemColor: const Color(0xFFB71C1C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// 1. HOME SCREEN & DASHBOARD
// -----------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;
  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFB71C1C),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello, Jhian',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Welcome to the Registrar\'s Office',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const QueueStatusScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Your Queue Number', style: TextStyle(color: Colors.black54, fontSize: 14)),
                                  const Text('A-023', style: TextStyle(color: Color(0xFFB71C1C), fontSize: 42, fontWeight: FontWeight.bold, height: 1)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 16, color: Colors.black54),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Estimated Wait: ~ 15 mins',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          backgroundColor: const Color(0xFFFFE082).withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const QueueStatusScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB71C1C).withOpacity(0.1),
                                foregroundColor: const Color(0xFFB71C1C),
                                elevation: 0,
                              ),
                              child: const Text('Waiting'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildShortcutIcon(
                            context,
                            Icons.book_online,
                            'Book\nAppointment',
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookAppointmentScreen())),
                          ),
                          _buildShortcutIcon(
                            context,
                            Icons.qr_code_scanner,
                            'Get\nQueue Status',
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QueueStatusScreen())),
                          ),
                          _buildShortcutIcon(
                            context,
                            Icons.calendar_today,
                            'My\nAppointments',
                            () {
                              if (onNavigateToTab != null) {
                                onNavigateToTab!(1);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsScreen()));
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text('Available Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 16),
                      _buildServiceTile(context, Icons.school_outlined, 'Enrollment/Registration'),
                      _buildServiceTile(context, Icons.description_outlined, 'Request for Documents'),
                      _buildServiceTile(context, Icons.folder_shared_outlined, 'Academic Records'),
                      _buildServiceTile(context, Icons.workspace_premium_outlined, 'Graduation & Clearance'),
                      _buildServiceTile(context, Icons.more_horiz, 'Others'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutIcon(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C).withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB71C1C).withOpacity(0.1)),
              ),
              child: Icon(icon, color: const Color(0xFFB71C1C), size: 30),
            ),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, height: 1.2, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C)),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12, width: 1)),
        tileColor: Colors.grey.shade50,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookAppointmentScreen(initialService: title),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// 2. BOOK APPOINTMENT SCREEN
// -----------------------------------------------------------------
class BookAppointmentScreen extends StatefulWidget {
  final String initialService;
  const BookAppointmentScreen({super.key, this.initialService = 'Enrollment/Registration'});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final List<String> _services = [
    'Enrollment/Registration',
    'Request for Documents',
    'Academic Records',
    'Graduation & Clearance',
    'Others',
  ];

  final List<String> _months = [
    'November 2026',
    'December 2026',
    'January 2027',
    'February 2027',
    'March 2027',
  ];

  final List<String> _timeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '1:00 PM',
    '2:00 PM',
  ];

  late String _selectedService;
  final TextEditingController _otherNoteController = TextEditingController();
  int _monthIndex = 3;
  int _selectedDay = 15;
  String _selectedTime = '9:00 AM';
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _selectedService = _services.contains(widget.initialService)
        ? widget.initialService
        : _services.first;
  }

  @override
  void dispose() {
    _otherNoteController.dispose();
    super.dispose();
  }

  void _handleNextOrConfirm() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      final serviceLabel = _selectedService == 'Others' && _otherNoteController.text.trim().isNotEmpty
          ? 'Others: ${_otherNoteController.text.trim()}'
          : _selectedService;

      final monthParts = _months[_monthIndex].split(' ');
      AppData.appointments.insert(
        0,
        AppointmentItem(
          title: serviceLabel,
          date: '${monthParts[0]} $_selectedDay, ${monthParts[1]}',
          time: _selectedTime,
          status: 'Confirmed',
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booked $serviceLabel on ${_months[_monthIndex]} $_selectedDay at $_selectedTime!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Book an Appointment', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(1, 'Service'),
                Container(width: 40, height: 2, color: _currentStep >= 2 ? const Color(0xFFB71C1C) : Colors.grey),
                _buildStepIndicator(2, 'Date & Time'),
                Container(width: 40, height: 2, color: _currentStep >= 3 ? const Color(0xFFB71C1C) : Colors.grey),
                _buildStepIndicator(3, 'Review'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Select Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedService,
                  isExpanded: true,
                  items: _services.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedService = newValue;
                        if (_currentStep == 1) _currentStep = 2;
                      });
                    }
                  },
                ),
              ),
            ),
            if (_selectedService == 'Others') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otherNoteController,
                decoration: InputDecoration(
                  hintText: 'Specify your request or concern...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 14),
                        onPressed: _monthIndex > 0 ? () => setState(() => _monthIndex--) : null,
                      ),
                      Text(_months[_monthIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 14),
                        onPressed: _monthIndex < _months.length - 1 ? () => setState(() => _monthIndex++) : null,
                      ),
                    ],
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Sun', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Mon', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Tue', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Wed', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Thu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Fri', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Sat', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: 28,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final isSelected = day == _selectedDay;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                            if (_currentStep < 2) _currentStep = 2;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFB71C1C) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$day',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) => _buildTimeSlot(slot)).toList(),
            ),
            if (_currentStep == 3) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB71C1C).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                    const SizedBox(height: 8),
                    Text('Service: $_selectedService'),
                    if (_selectedService == 'Others' && _otherNoteController.text.isNotEmpty)
                      Text('Details: ${_otherNoteController.text}'),
                    Text('Date: ${_months[_monthIndex]} $_selectedDay'),
                    Text('Time: $_selectedTime'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleNextOrConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentStep < 3 ? 'Next' : 'Confirm Booking',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepNumber, String label) {
    final bool isActive = _currentStep >= stepNumber;
    return GestureDetector(
      onTap: () => setState(() => _currentStep = stepNumber),
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isActive ? const Color(0xFFB71C1C) : Colors.grey.shade300,
            child: Text('$stepNumber', style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontSize: 12)),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFFB71C1C) : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    final bool isSelected = _selectedTime == time;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTime = time;
          if (_currentStep < 2) _currentStep = 2;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB71C1C) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFFB71C1C) : Colors.grey.shade300),
        ),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 3. QUEUE STATUS SCREEN
// -----------------------------------------------------------------
class QueueStatusScreen extends StatefulWidget {
  const QueueStatusScreen({super.key});

  @override
  State<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  final List<String> _queueServices = [
    'Enrollment / Registration',
    'Request for Documents',
    'Academic Records',
    'Graduation & Clearance',
    'Others',
  ];

  String _selectedService = 'Enrollment / Registration';
  bool _showFullLog = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        title: const Text('Queue Number', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              child: ListView(
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Text('Your Queue Number', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('A-023', style: TextStyle(color: Color(0xFFB71C1C), fontSize: 40, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Service', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedService,
                        isExpanded: true,
                        items: _queueServices.map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedService = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Current Counter', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'A-02 / Processing',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Queue Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text('On Queue', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Estimated Waiting Time\n15 mins', style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showFullLog = !_showFullLog;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_showFullLog ? 'Hide Queue Status Log' : 'View Queue Status Log', style: const TextStyle(fontSize: 16)),
                  ),
                  // "Please be at the waiting area" text has been removed from here
                  if (_showFullLog) ...[
                    const Divider(height: 30),
                    _buildStatusLogItem('Neil@mcc.edu.ph', 'Completed', Colors.teal, '7:30am Aug 11, 2026'),
                    _buildStatusLogItem('Neil@mcc.edu.ph', 'Called', Colors.green, '7:30am Aug 11, 2026'),
                    _buildStatusLogItem('Neil@mcc.edu.ph', 'Now Serving', Colors.brown, '7:30am Aug 11, 2026'),
                    _buildStatusLogItem('Neil@mcc.edu.ph', 'Waiting', Colors.blue, '7:30am Aug 11, 2026'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLogItem(String email, String status, Color statusColor, String timestamp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const Text('Counter A-01', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(timestamp, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// 4. APPOINTMENTS TAB SCREEN
// -----------------------------------------------------------------
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  void _showAppointmentDetails(int index) {
    final item = AppData.appointments[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${item.date}'),
            Text('Time: ${item.time}'),
            Text('Status: ${item.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                AppData.appointments.removeAt(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment cancelled.')),
              );
            },
            child: const Text('Cancel Appointment', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AppData.appointments.isEmpty
          ? const Center(child: Text('No scheduled appointments yet.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: AppData.appointments.length,
              itemBuilder: (context, index) {
                final item = AppData.appointments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Color(0xFFB71C1C)),
                    title: Text(item.title),
                    subtitle: Text('Date: ${item.date} | ${item.time}'),
                    trailing: Chip(
                      label: Text(item.status, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    ),
                    onTap: () => _showAppointmentDetails(index),
                  ),
                );
              },
            ),
    );
  }
}

// -----------------------------------------------------------------
// 5. NOTIFICATIONS SCREEN
// -----------------------------------------------------------------
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.description,
      title: 'Your queue number A-023 is now being served.',
      subtitle: '09:42 AM',
      details: 'Please proceed immediately to Counter A-02 at the Registrar\'s Office.',
      read: false,
    ),
    NotificationItem(
      icon: Icons.calendar_month,
      title: 'Your appointment for Enrollment is confirmed.',
      subtitle: 'Sept. 16, 2026   09:30 AM',
      details: 'Your slot for Enrollment/Registration has been approved. Please arrive 10 minutes early.',
      read: false,
    ),
    NotificationItem(
      icon: Icons.notifications_active,
      title: 'Reminder: Bring necessary document for your appointment.',
      subtitle: 'Sept. 12, 2026   10:30 AM',
      details: 'Don\'t forget to bring your valid MCC Student ID and clearance form.',
      read: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _notifications.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return ListTile(
              tileColor: item.read ? Colors.transparent : const Color(0xFFB71C1C).withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: Icon(item.icon, color: const Color(0xFFB71C1C)),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: item.read ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11)),
              onTap: () {
                setState(() {
                  item.read = true;
                });
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Notification Details'),
                    content: Text(item.details),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK', style: TextStyle(color: Color(0xFFB71C1C))),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 6. PROFILE SCREEN
// -----------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Current Password')),
            SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'New Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'MCC Registrar\'s Office Helpdesk\n\n'
          'Email: registrar@mcc.edu.ph\n'
          'Hours: Mon–Fri, 8:00 AM – 5:00 PM\n\n'
          'Need assistance with your queue ticket? Visit Window 1.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Color(0xFFB71C1C), child: Icon(Icons.person, size: 40, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Cunanan Jhian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Student', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileField('Student ID', '2023-12345'),
            _buildProfileField('Program', 'BSIT'),
            _buildProfileField('Year Level', '3rd Year'),
            _buildProfileField('Email', 'Cunananmcc@gmail.com'),
            _buildProfileField('Phone', '+63 245 432 9876'),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: Color(0xFFB71C1C)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _showChangePasswordDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFFB71C1C)),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _showHelpSupportDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFB71C1C)),
              title: const Text('Log Out', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold)),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}