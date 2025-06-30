import router from '@ohos.router';
import { BottomTabs } from '../components/BottomTabs';

@Entry
@Component
struct VideoPage{
  build(){
    Column() {
      BottomTabs()
    }.width('100%').height('100%')
  }
}