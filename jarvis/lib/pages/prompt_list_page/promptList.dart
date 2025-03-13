import 'package:flutter/material.dart';

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});
  @override
  Widget build(BuildContext context) {
    return PromptScreen();
  }

}

class PromptScreen extends StatelessWidget{
  final List<Prompt> prompts = [
    Prompt(title: 'Chatbot AI', description: 'Hỗ trợ trả lời câu hỏi nhanh chóng và chính xác.'),
    Prompt(title: 'Phân tích văn bản', description: 'Phân tích và xử lý văn bản chuyên sâu.'),
    Prompt(title: 'Tạo hình ảnh AI', description: 'Sử dụng AI để tạo hình ảnh từ mô tả.'),
    Prompt(title: 'Dịch ngôn ngữ', description: 'Dịch ngôn ngữ tự động qua AI.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step AI', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF373FA9),
      ),
      body: Padding(padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Text(
              'Prompt Gallery',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF373FA9),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Explore prompt ideas.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF373FA9),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
                  itemBuilder: (context, index){
                    return PromptCard(
                      prompt: prompts[index],
                      onTap: (){
                        print("Clicked");
                      },
                    );
                  },
                  itemCount: prompts.length,
                ),
            ),

          ],
        ),
      ),
    );
  }
  

}

class Prompt {
  final String title;
  final String description;

  Prompt({required this.title, required this.description});
}

class PromptCard extends StatelessWidget {
  final Prompt prompt;
  final VoidCallback onTap;

  const PromptCard({Key? key, required this.prompt, required this.onTap}): super (key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, //Background color
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Color(0xFF373FA9),
            width: 2.0,
          ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          splashColor: Color(0xFF373FA9).withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  prompt.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF373FA9),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  prompt.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF373FA9),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}