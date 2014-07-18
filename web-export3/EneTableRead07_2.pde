EneTable ene;
String[] filelist;
int dataNum = 0;
int hour = 0;
PVector[] pos = new PVector[110];
PVector[] vel = new PVector[110];

void setup() {
  // 画面初期化
  size(800, 600);
  noStroke();
  frameRate(30);
  textSize(15);

  for (int i = 0; i < pos.length; i++) {
    pos[i] = new PVector();
    pos[i].x = random(800,width);
    pos[i].y = random(100,height);
    vel[i] = new PVector();
    vel[i].x = random(-2, 0);
    //vel[i].y = random(0, -2);
    vel[i].y = 0;
  }

  filelist = loadStrings("filelist.txt"); 
  // データ読み込み用クラスEneTableをインスタンス化（初期化）
  ene = new EneTable(filelist[dataNum]);
}

// 結果を表示
void draw() {
  // 背景
  fill(100,200,200, 30);
  rect(0, 0, width, height);
  fill(200);
  rect(0,-550, width, height);

  // 行と列の数だけ繰り返し  
  for (int i = 0; i < ene.data.length-1; i++) {
    // データの数値を表示
     int value = int(map(ene.data[i][hour], 0, 1200, 0, 1000));
    float diameter = map(ene.data[i][hour], 0, 1200, 5, 300);
    if (value > 320) {
      value = 320;
    }
   fill(value, 0, 400-value);
    ellipse(pos[i].x, pos[i].y, diameter, diameter);
    pos[i].add(vel[i]);
    if (pos[i].x < 0 || pos[i].x > width) {
      vel[i].x *= -1;
    }
    if (pos[i].y < 0 || pos[i].y > height) {
      vel[i].y *= -1;
    }
  }

  // 日付
  fill(255);
  text(ene.date + " "  + hour + ":00", 10, 30);

  // 一つ先のファイルを再読み込み
  // データ番号を更新
  hour++;
  if (hour > 23) {
    hour = 0;
    dataNum++;
    // もしファイル数よりも多ければリセット
    if (dataNum > filelist.length - 1) {
      dataNum = 0;
    }
    // クラスを再度初期化する
    ene = new EneTable(filelist[dataNum]);
  }
}
// EneTable
// 電力データ読み込み用クラス

class EneTable {
  String date;  // 日付
  int data[][]; // データ

  // コンストラクタ（初期化関数）
  // ファイルを指定して、データをパース
  EneTable(String filename) {
    String[] rows = loadStrings(filename);
    String[] header = split(rows[0], ",");
    date = header[1];    
    data = new int[rows.length - 1][];

    for (int i = 1; i < rows.length - 1; i++) {
      int[] row = int(split(rows[i], ","));
      data[i - 1] = (int[]) subset(row, 1);
    }
  }

  float getRowsMin(int row) {
    float m = Float.MAX_VALUE;
    for (int col = 0; col < data[row].length; col++) {
      if (data[row][col] < m) {
        m = data[row][col];
      }
    }
    return m;
  }
  
  float getRowsMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int col = 0; col < data[row].length; col++) {
      if (data[row][col] > m) {
        m = data[row][col];
      }
    }
    return m;
  }
}


