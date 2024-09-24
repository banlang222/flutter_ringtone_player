import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { media } from '@kit.MediaKit';
import { audio} from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';

/** FlutterRingtonePlayerPlugin **/
export default class FlutterRingtonePlayerPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  private soundPool: media.SoundPool | null = null;
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
    rendererFlags: 0
  };

  private soundID: number | null = null;
  private streamID: number | null = null;
  private playParameters: media.PlayParameters = {
    loop:0,
    rate: 0,
    leftVolume: 1.0,
    rightVolume: 1.0,
    priority: 9
  }

  constructor() {
    media.createSoundPool(5, this.audioRendererInfo).then((soundPool_: media.SoundPool)=> {
      if(soundPool_ != null) {
        this.soundPool = soundPool_;
        console.debug('sound pool create success');
        this.soundPool.on("error", (error:BusinessError)=>{
          console.log(`sound pool error:${JSON.stringify(error)}`);
        });
      } else {
        console.debug('sound pool create fail');
      }
    }).catch((error:BusinessError)=>{
      console.debug(`catch error:${JSON.stringify(error)}`);
    });
  }

  getUniqueClassName(): string {
    return "FlutterRingtonePlayerPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_ringtone_player");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if(call.method == "play") {
      let uri: string = call.argument('uri');
      console.debug(`uri=${uri}`);
      if(!uri) {
        console.debug('uri must exists');
        result.error('1', 'uri must exists', null);
        return;
      }
      let file: fileIo.File = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      console.debug(`filePath=${file.path}, fd://${file.fd.toString()}}`);
      this.soundPool?.on("playFinished", ()=>{
        this.soundPool?.unload(this.soundID, ()=>{
          this.soundID = null;
          this.soundPool?.off("playFinished");
        });

      });

      this.soundPool?.on("loadComplete", ()=>{
        console.debug('sound load complete');
        this.soundPool?.play(this.soundID, this.playParameters, (error:BusinessError, streamID: number)=>{
          if(error) {
            console.debug(`play error:${JSON.stringify(error)}`);
            result.error('3', 'play error', null);
          } else {
            this.streamID = streamID;
            console.debug(`play success, streamID=${streamID}`);
            result.success(null);
          }
        });

        this.soundPool?.off("loadComplete");
      });

      this.soundPool?.load('fd://' + file.fd.toString()).then((soundID: number)=>{
        this.soundID = soundID;
        console.debug(`load success, soundID=${soundID}`);
      }).catch((error: BusinessError)=>{
        console.debug(`sound pool load catch error:${JSON.stringify(error)}`);
        result.error('2', 'load error', null);
      });

    } else if(call.method == "stop") {
      this.soundPool?.stop(this.streamID);
      result.success(null);
    }
    else {
      result.notImplemented()
    }
  }

}