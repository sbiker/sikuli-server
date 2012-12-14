mkdir bin
javac -d bin -sourcepath src -cp lib/gson-2.2.2.jar src/*.java
java -cp bin:lib/gson-2.2.2.jar Main
