#!/usr/bin/env node

/**
 * 音声生成スクリプト
 * 
 * このスクリプトは、OpenAI の音声生成 API を使用して、
 * 例文の音声ファイルを生成します。
 * 
 * 使用方法:
 * 1. OPENAI_API_KEY 環境変数を設定
 * 2. node generate_audio.js を実行
 * 
 * オプション:
 * --voice <voice>: 音声の種類（alloy, echo, fable, onyx, nova, shimmer）
 * --model <model>: モデル（gpt-4o-mini-tts, tts-1, tts-1-hd）
 * --lesson <lesson>: レッスンタイプ（elision, flap_t, linking, reduction）
 * --id <id>: 例文ID（例: elision_1）
 * 
 * 例: node generate_audio.js --voice alloy --lesson elision
 * node generate_audio.js --id elision_1
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const { execSync } = require('child_process');

// 設定
const CONFIG = {
  // OpenAI API の設定
  openai: {
    apiKey: process.env.OPENAI_API_KEY,
    model: 'gpt-4o-mini-tts', // デフォルトモデル
    voice: 'nova', // デフォルト音声
  },
  voices: {
    instructions: `
      Identity:
      American speaker in their early 30s, calm and confident, working in a collaborative business setting—like tech or creative teams.

      Affect:
      Friendly, thoughtful, and composed. Feels like someone speaking clearly in a casual meeting or team chat.

      Tone:
      Professional but relaxed. Uses natural contractions and smooth phrasing. Speech is intentional, never stiff or over-acted.

      Emotion:
      Warm, helpful, and present. The speaker sounds engaged and approachable, without being overly enthusiastic.

      Pronunciation:
      General American. Clear and fluent with linking and reductions (e.g., "gonna", "wanna"). Speech flows smoothly and sounds authentically native, but not exaggerated.`,
  },
  // パス設定
  paths: {
    audio: path.join(__dirname, '..', 'assets', 'audio'),
    data: path.join(__dirname, '..', 'lib', 'models', 'lesson_data.dart'),
  },
};

// コマンドライン引数の解析
function parseArgs() {
  const args = process.argv.slice(2);
  const options = {
    voice: CONFIG.openai.voice, // デフォルト値を設定
    model: CONFIG.openai.model,
    lesson: null,
    id: null,
  };

  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--voice' && i + 1 < args.length) {
      options.voice = args[i + 1];
      i++;
    } else if (args[i] === '--model' && i + 1 < args.length) {
      options.model = args[i + 1];
      i++;
    } else if (args[i] === '--lesson' && i + 1 < args.length) {
      options.lesson = args[i + 1];
      i++;
    } else if (args[i] === '--id' && i + 1 < args.length) {
      options.id = args[i + 1];
      i++;
    }
  }

  return options;
}

// 例文データの解析
function parseExampleSentences(dartCode) {
  const examples = [];
  const regex = /ExampleSentence\(\s*id:\s*'([^']+)',\s*text:\s*'([^']+)'/gs;
  
  let match;
  while ((match = regex.exec(dartCode)) !== null) {
    examples.push({
      id: match[1],
      text: match[2],
    });
  }
  
  return examples;
}

// OpenAI API を使用して音声を生成
async function generateAudio(text, options, outputPath) {
  return new Promise((resolve, reject) => {
    // API リクエストのデータ
    const voiceInstructions = CONFIG.voices.instructions || '';
    
    const data = JSON.stringify({
      model: options.model,
      input: text,
      voice: options.voice,
      response_format: 'mp3',
      speed: 1.0,
      // 音声の特性を指定する場合は voice_instructions を追加
      ...(voiceInstructions ? { voice_instructions: voiceInstructions } : {}),
    });

    // API リクエストのオプション
    const requestOptions = {
      hostname: 'api.openai.com',
      port: 443,
      path: '/v1/audio/speech',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${CONFIG.openai.apiKey}`,
        'Content-Length': Buffer.byteLength(data),
      },
    };

    // API リクエストの作成
    const req = https.request(requestOptions, (res) => {
      if (res.statusCode !== 200) {
        let error = '';
        res.on('data', (chunk) => {
          error += chunk;
        });
        res.on('end', () => {
          reject(new Error(`API request failed with status ${res.statusCode}: ${error}`));
        });
        return;
      }

      // 音声データの保存
      const file = fs.createWriteStream(outputPath);
      res.pipe(file);
      
      file.on('finish', () => {
        file.close();
        console.log(`音声ファイルを保存しました: ${outputPath}`);
        resolve(outputPath);
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    // リクエストデータの送信
    req.write(data);
    req.end();
  });
}

// メイン関数
async function main() {
  try {
    // コマンドライン引数の解析
    const options = parseArgs();
    
    // OpenAI API キーの確認
    if (!CONFIG.openai.apiKey) {
      console.error('エラー: OPENAI_API_KEY 環境変数が設定されていません。');
      process.exit(1);
    }

    // 音声ディレクトリの作成
    if (!fs.existsSync(CONFIG.paths.audio)) {
      fs.mkdirSync(CONFIG.paths.audio, { recursive: true });
      console.log(`ディレクトリを作成しました: ${CONFIG.paths.audio}`);
    }

    // 例文データの読み込み
    const dartCode = fs.readFileSync(CONFIG.paths.data, 'utf8');
    const examples = parseExampleSentences(dartCode);
    
    if (examples.length === 0) {
      console.error('エラー: 例文データが見つかりませんでした。');
      process.exit(1);
    }

    console.log(`${examples.length} 件の例文が見つかりました。`);

    // 処理対象の例文をフィルタリング
    let targetExamples = examples;
    
    if (options.id) {
      targetExamples = examples.filter(ex => ex.id === options.id);
      if (targetExamples.length === 0) {
        console.error(`エラー: ID "${options.id}" の例文が見つかりませんでした。`);
        process.exit(1);
      }
    } else if (options.lesson) {
      targetExamples = examples.filter(ex => ex.id.startsWith(options.lesson));
      if (targetExamples.length === 0) {
        console.error(`エラー: レッスン "${options.lesson}" の例文が見つかりませんでした。`);
        process.exit(1);
      }
    }

    console.log(`${targetExamples.length} 件の例文を処理します。`);

    // 各例文に対して音声を生成
    for (const example of targetExamples) {
      const outputPath = path.join(CONFIG.paths.audio, `${example.id}.mp3`);
      
      console.log(`例文 "${example.id}" の音声を生成中...`);
      console.log(`テキスト: ${example.text}`);
      
      await generateAudio(example.text, options, outputPath);
    }

    console.log('音声生成が完了しました。');
  } catch (error) {
    console.error('エラーが発生しました:', error);
    process.exit(1);
  }
}

// スクリプトの実行
main();
