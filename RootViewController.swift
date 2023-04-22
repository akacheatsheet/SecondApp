import UIKit

class RootViewController: UIViewController {
	private var initialScore: Int = 123
	private let scoreInc: Int = 1
	
	func createScoreLabel() -> UILabel {
		let scoreLabel: UILabel = UILabel()
		scoreLabel.backgroundColor = .gray
		scoreLabel.textColor = .cyan
		scoreLabel.font = UIFont(name: "AppleGothic", size: 14)
		scoreLabel.textAlignment = NSTextAlignment.center;
		scoreLabel.numberOfLines = 0;
		return scoreLabel;
	}
	
	/* ナマ */
	private var scoreRawLabel: UILabel = UILabel()
	private let scoreRawLabelText: String = "生 score"
	private var score: Int = 0
	
	// ナマのハッシュ値(検知用)
	private var scoreHash: Int = 0
	
	func initScoreRaw(score: Int) {
		self.score = score
		self.scoreHash = self.hashScore(score: score);
	}
	
	func hashScore(score: Int) -> Int {
		score ^ 777
	}
	
	func reflectScoreRawLabelText() {
		let pointer = withUnsafePointer(to: &self.score) { (ptr:UnsafePointer) in
			UnsafePointer<Int>(ptr)
		}
		self.scoreRawLabel.text = "\(self.scoreRawLabelText): \(self.score)\naddr: \(pointer)"
	}
	
	func addScoreRaw() {
		let hashValue = self.hashScore(score: self.score);
		if (hashValue != self.scoreHash) {
			withUnsafePointer(to: self.score) {
				self.scoreRawLabel.text = "チート検知\n\(self.scoreRawLabelText): \(self.score)\naddr: \($0)"
			}
			self.scoreRawLabel.textColor = .red
			return;
		}
		self.score += self.scoreInc;
		self.scoreHash = self.hashScore(score: self.score);
		
		self.reflectScoreRawLabelText()
	}
	
	func createScoreRawLabel(rect: CGRect) {
		self.scoreRawLabel = self.createScoreLabel()
		self.scoreRawLabel.frame = rect;
		self.reflectScoreRawLabelText()
		self.view.addSubview(self.scoreRawLabel)
	}
	
	/* ナマ end */
	
	/* 差分 */
	private var scoreDiffLabel: UILabel = UILabel()
	private let scoreDiffLabelText: String = "初期との差分 score"
	private var scoreInced: Int = 0
	
	func initScoreDiff(score: Int) {
		self.scoreInced = 0;
	}
	
	func reflectScoreDiffLabelText() {
		let initialScorePointer = withUnsafePointer(to: &self.initialScore) { (ptr:UnsafePointer) in
			UnsafePointer<Int>(ptr)
		}
		let scoreIncedPointer = withUnsafePointer(to: &self.scoreInced) { (ptr:UnsafePointer) in
			UnsafePointer<Int>(ptr)
		}
		self.scoreDiffLabel.text = "\(self.scoreDiffLabelText): \(self.initialScore + self.scoreInced)\n初期値 addr: \(initialScorePointer) val: \(self.initialScore)\n差分 addr: \(scoreIncedPointer) val: \(self.scoreInced)"
	}
	
	func addScoreDiff() {
		self.scoreInced += self.scoreInc;
		
		self.reflectScoreDiffLabelText()
	}
	
	func createScoreDiffLabel(rect: CGRect) {
		self.scoreDiffLabel = self.createScoreLabel()
		self.scoreDiffLabel.frame = rect;
		self.reflectScoreDiffLabelText()
		self.view.addSubview(self.scoreDiffLabel)
	}
	/* 差分 end */
	
	/* ファイル */
	private var scoreFileLabel: UILabel = UILabel()
	private let scoreFileLabelText: String = "ファイル保存 score"
	private var filepath: URL? = nil
	
	func initScoreFile(score: Int) {
		self.initFilePath()
		self.backupScoreFile(score: score)
	}
	
	func initFilePath() {
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			self.filepath = dir.appendingPathComponent("score.txt")
		}
	}
	
	func restoreScoreFile() -> Int {
		if let filepath = self.filepath {
			do {
				let content = try String(contentsOf: filepath, encoding: .utf8)
				return Int(content) ?? 0
			}
			catch {/* error handling here */}
		}
		
		return 0
	}
	
	func reflectScoreFileLabelText(score: Int) {
		self.scoreFileLabel.text = "\(self.scoreFileLabelText): \(score)"
	}
	
	func addScoreFile() {
		let newScore = self.restoreScoreFile() + self.scoreInc;
		backupScoreFile(score: newScore)
		
		self.reflectScoreFileLabelText(score: newScore)
	}
	
	func backupScoreFile(score: Int) {
		if let filepath = self.filepath {
			do {
				try "\(score)".write(to: filepath, atomically: true, encoding: .utf8)
			}
			catch {
			}
		}
	}
	
	func createScoreFileLabel(rect: CGRect) {
		self.scoreFileLabel = self.createScoreLabel()
		self.scoreFileLabel.frame = rect;
		self.reflectScoreFileLabelText(score: score)
		self.view.addSubview(self.scoreFileLabel)
	}
	/* ファイル end */
	
	/* xor */
	private var scoreXorLabel: UILabel = UILabel()
	private let scoreXorLabelText: String = "排他的論理和 score"
	private var backupXor01: Int = 0
	private var backupXor02: Int = 0
	
	func initScoreXor(score: Int) {
		self.backupScoreXor(score: score)
	}
	
	func backupScoreXor(score: Int) {
		self.backupXor01 = Int.random(in: Int.min..<Int.max)
		self.backupXor02 = score ^ self.backupXor01;
	}
	
	func reflectScoreXorLabelText(score: Int) {
		let backupXor01Pointer = withUnsafePointer(to: &self.backupXor01) { (ptr:UnsafePointer) in
			UnsafePointer<Int>(ptr)
		}
		let backupXor02Pointer = withUnsafePointer(to: &self.backupXor02) { (ptr:UnsafePointer) in
			UnsafePointer<Int>(ptr)
		}
		self.scoreXorLabel.text = "\(self.scoreXorLabelText): \(score)\nxor01 addr: \(backupXor01Pointer) val: \(self.backupXor01)\nxor02 addr: \(backupXor02Pointer) val: \(self.backupXor02)"
	}
	
	func addScoreXor() {
		var score = self.restoreScoreXor()
		score += self.scoreInc;
		self.backupScoreXor(score: score)
		
		self.reflectScoreXorLabelText(score: score)
	}
	
	func restoreScoreXor() -> Int {
		self.backupXor01 ^ self.backupXor02;
	}
	
	func createScoreXorLabel(rect: CGRect) {
		self.scoreXorLabel = self.createScoreLabel()
		self.scoreXorLabel.frame = rect;
		self.reflectScoreXorLabelText(score: self.restoreScoreXor())
		self.view.addSubview(self.scoreXorLabel)
	}
	/* xor end */
	
	func initScore(score: Int) {
		// ナマ
		self.initScoreRaw(score: score)
		
		// 差分
		self.initScoreDiff(score: score)
		
		// ファイル
		self.initScoreFile(score: score)
		
		// xor
		self.initScoreXor(score: score)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let scoreLabelCount: Int = 4
		let padding: CGFloat = 10
		
		var labelY: CGFloat = UIApplication.shared.statusBarFrame.height
		let viewWidth = self.view.bounds.size.width
		let viewHeight = self.view.bounds.size.height - labelY
		let scoreLabelHeight = (viewHeight * 0.5 - CGFloat(scoreLabelCount) * padding) / CGFloat(scoreLabelCount)
		
		self.initScore(score: initialScore)
		
		// ナマ
		self.createScoreRawLabel(rect: CGRect(x: 10, y: labelY, width: viewWidth - 20, height: scoreLabelHeight))
		labelY += scoreLabelHeight + padding
		
		// 差分
		self.createScoreDiffLabel(rect: CGRect(x: 10, y: labelY, width: viewWidth - 20, height: scoreLabelHeight))
		labelY += scoreLabelHeight + padding
		
		// ファイル
		self.createScoreFileLabel(rect: CGRect(x: 10, y: labelY, width: viewWidth - 20, height: scoreLabelHeight))
		labelY += scoreLabelHeight + padding
		
		// xor
		self.createScoreXorLabel(rect: CGRect(x: 10, y: labelY, width: viewWidth - 20, height: scoreLabelHeight))
		labelY += scoreLabelHeight + padding
		
		let tapLabel: UILabel = UILabel()
		tapLabel.frame = CGRect(x: 10, y: labelY, width: viewWidth - 20, height: self.view.bounds.size.height - labelY - padding)
		tapLabel.backgroundColor = .gray
		tapLabel.textColor = .cyan
		tapLabel.font = UIFont(name: "AppleGothic", size: 26)
		tapLabel.textAlignment = NSTextAlignment.center
		tapLabel.layer.cornerRadius = 38.5
		tapLabel.clipsToBounds = true
		tapLabel.text = "タップせよ"
		
		let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RootViewController.handleSingleTap(_:)))
		tapLabel.isUserInteractionEnabled = true;
		tapLabel.addGestureRecognizer(tapGestureRecognizer)
		self.view.addSubview(tapLabel)
		
		let resetButton: UIButton = UIButton(type: .roundedRect)
		resetButton.backgroundColor = .red
		resetButton.setTitleColor(.white, for: .normal)
		resetButton.setTitle("リセット", for: .normal)
		resetButton.titleLabel?.font = UIFont(name: "", size: 14)
		resetButton.sizeToFit()
		resetButton.frame = CGRect(x: viewWidth - resetButton.frame.width * 1.5, y: self.view.bounds.size.height - resetButton.frame.width * 1.5, width: resetButton.frame.width, height: resetButton.frame.width)
		resetButton.layer.masksToBounds = true
		resetButton.layer.cornerRadius = resetButton.frame.size.width / 2
		resetButton.addTarget(self, action: #selector(RootViewController.resetScore), for: .touchDown)
		self.view.addSubview(resetButton)
	}
	
	@objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
		if (sender.state == UIGestureRecognizer.State.ended) {
			// ナマ
			self.addScoreRaw()
			
			// 差分
			self.addScoreDiff()
			
			// ファイル
			self.addScoreFile()
			
			// xor
			self.addScoreXor()
		}
	}
	
	@objc func resetScore(_ sender: UIButton) {
		self.initScore(score: initialScore)
		
		// ナマ
		self.reflectScoreRawLabelText()
		self.scoreRawLabel.textColor = .cyan
		
		// 差分
		self.reflectScoreDiffLabelText()
		
		// ファイル
		self.reflectScoreFileLabelText(score: score)
		
		// xor
		self.reflectScoreXorLabelText(score: score)
	}
	
}