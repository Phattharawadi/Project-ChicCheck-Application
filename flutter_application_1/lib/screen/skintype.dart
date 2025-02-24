import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/quizcomplete.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SkinTypeQuizScreen(),
      debugShowCheckedModeBanner: false, // ปิดแบนเนอร์ debug
    );
  }
}

class SkinTypeQuizScreen extends StatefulWidget {
  @override
  _SkinTypeQuizScreenState createState() => _SkinTypeQuizScreenState();
}

class _SkinTypeQuizScreenState extends State<SkinTypeQuizScreen> {
  int _currentQuestionIndex = 0;
  late List<int> _selectedOptions; // List to store the selected option index for each question

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is your skin type?",
      "options": [
        'Oily skin',
        'Dry skin',
        'Combination skin(oily in the T-zone)',
        'Sensitive skin',
        'Normal Skin',
        'Acne'
      ],
    },
    {
      "question": "What type of skincare products do you like most or use regularly?",
      "options": [
        "Anti-aging skincare products",
        "Brightening skincare products",
        "Acne treatment products (inflammatory acne and blackheads)",
        "Melasma and freckle treatment products",
        "Supplements (e.g., vitamins)",
        "Weight loss supplements"
      ],
    },
    {
      "question": "Which 3 products do you consider most important?",
      "options": [
        "Face cream",
        "Body lotion",
        "Facial cleanser",
        "Eye cream",
        "Sunscreen",
        "Mask",
        
      ],
    },
    {
      "question": "What type of makeup remover do you prefer?",
      "options": [
        "Water-based",
        "Lotion-based",
        "Oil-based",
        "Foam-based"
      ],
    },
    {
      "question": "What type of facial skincare products do you prefer?",
      "options": [
        "Cream",
        "Lotion",
        "Serum",
        "Gel"
      ],
    },
    {
      "question": "What body skin problems do you have?",
      "options": [
        "Uneven skin tone, lack of radiance",
        "Persistent stretch marks",
        "Very dry skin, dehydrated, flaky",
        "Uneven underarms, chicken skin, dark spots"
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.filled(_questions.length, -1); // Initializing selected options with -1
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProgressBar(),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(
                fontSize: screenWidth * 0.05, // 5% ของความกว้างหน้าจอ
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 121, 21, 55),
              ),
            ),
            SizedBox(height: 20),
            _buildImage(),
            SizedBox(height: 20),
            ..._buildOptionButtons(context),
            SizedBox(height: 20),
            _buildNavigationRow(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Icon(Icons.close, color: const Color.fromARGB(255, 235, 127, 163)),
      title: Text(
        'Skin Type Quiz',
        style: TextStyle(color: const Color.fromARGB(255, 255, 254, 254)),
      ),
      backgroundColor:  const Color.fromARGB(255, 193, 72, 118),
      actions: [
        Icon(Icons.notifications, color: Colors.grey),
      ],
    );
  }

  LinearProgressIndicator _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / _questions.length,
      backgroundColor: Colors.pink.shade100,
      color: const Color.fromARGB(255, 124, 3, 63),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Image.network(
          'https://i.pinimg.com/736x/ed/51/36/ed51369590b7f9370c22aca41238a1ef.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<Widget> _buildOptionButtons(BuildContext context) {
    List<String> options = _questions[_currentQuestionIndex]['options'];

    return options.asMap().entries.map((entry) {
      int idx = entry.key;
      String title = entry.value;
      return buildOptionButton(context, title, idx);
    }).toList();
  }

  Row _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (_currentQuestionIndex > 0)
          _buildNavigationButton(Icons.arrow_back, _goToPreviousQuestion),
        if (_currentQuestionIndex < _questions.length - 1)
          _buildNavigationButton(Icons.arrow_forward, _goToNextQuestion),
        if (_currentQuestionIndex == _questions.length - 1)
          _buildSubmitButton(),
      ],
    );
  }

  ElevatedButton _buildNavigationButton(IconData icon, Function onPressed) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Colors.pink.shade100,
        fixedSize: Size(60, 60),
        elevation: 5, // เพิ่มเงาให้ปุ่ม
      ),
      child: Icon(
        icon,
        color: const Color.fromARGB(255, 146, 12, 72),
        size: 30,
      ),
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitQuiz,
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: const Color.fromARGB(255, 246, 139, 178),
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
      ),
      child: Text(
        "Submit",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget buildOptionButton(BuildContext context, String title, int idx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _selectOption(idx),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedOptions[_currentQuestionIndex] == idx 
                ? Colors.white 
                : Colors.pink.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: _selectedOptions[_currentQuestionIndex] == idx 
                ? Colors.pink.shade100 
                : const Color.fromARGB(255, 131, 2, 60),
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void _selectOption(int idx) {
    setState(() {
      _selectedOptions[_currentQuestionIndex] = idx;
    });
  }

  void _goToPreviousQuestion() {
    setState(() {
      _currentQuestionIndex--;
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _submitQuiz() {
    // Implement your logic for when the quiz is finished, for example:
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizResultScreen()),
    );
  }
}

