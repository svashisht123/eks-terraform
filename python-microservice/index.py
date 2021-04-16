from flask import Flask, request, render_template
app = Flask(__name__)


@app.route("/")
def my_form():
    return render_template("home.html")

@app.route('/', methods=['POST'])
def my_form_post():
    #user_input = request.form['text']
    user_input = request.form['text']

    cloud_list = ["Oracle","Google","Microsoft","Amazon","Deloitte"]
    #user_input = 'We really like the new security features of GooGLe Cloud'

    split_user_input = user_input.split(' ')
    final_user_input = ""
    matched_word = ""
    #print(split_user_input)

    def find_and_replace(user_input,final_user_input,matched_word):

        for (index, words) in enumerate(cloud_list):
            #print(words)
            for (index, keyword) in enumerate(split_user_input):
                if words==keyword.lower():
                    matched_word = words
        
        #print(matched_word)
        if matched_word != "":
        
            print ("word found is: " + matched_word)
            
            for (index, keyword) in enumerate(split_user_input):
                if matched_word in keyword.lower():
                    final_word = split_user_input[index] + "\u00a9"
                    final_user_input = user_input.replace(split_user_input[index], final_word)
        return final_user_input  
        #return render_template("home.html")
        
    final_user_input = find_and_replace(user_input,final_user_input,matched_word)

    if final_user_input != "":
        print (final_user_input)
    else:
        print("Cloud name is not specified in the user input")
        final_user_input = "Cloud name is not specified in the user input"
    return final_user_input
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)
    
