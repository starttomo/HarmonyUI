// pages/Register.ets
import router from '@ohos.router';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State showSuccess: boolean = false;
  @State passwordVisible: boolean = false;
  @State confirmPasswordVisible: boolean = false;

  build() {
    Column() {
      if (!this.showSuccess) {
        // 注册表单
        Column() {
          // 用户名输入
          Column() {
            Text('用户名')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({ placeholder: '请输入用户名' })
              //.text(this.username)
              .type(InputType.Normal)
              .onChange((value: string) => {
                this.username = value;
              })
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 20 })
          }
          .width('80%')

          // 密码输入
          Column() {
            Text('密码')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({ placeholder: '请输入密码' })
              //.text(this.password)
              .type(this.passwordVisible ? InputType.Normal : InputType.Password)
              .onChange((value: string) => {
                this.password = value;
              })
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 10 })

            // 密码可见性切换
            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: this.passwordVisible })
                .onChange((isOn: boolean) => {
                  this.passwordVisible = isOn;
                })
                .size({ width: 24, height: 24 })

              Text('显示密码')
                .fontSize(14)
                .margin({ left: 5 })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .margin({ bottom: 20 })
          }
          .width('80%')

          // 确认密码输入
          Column() {
            Text('确认密码')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({ placeholder: '请确认密码' })
              //.text(this.confirmPassword)
              .type(this.confirmPasswordVisible ? InputType.Normal : InputType.Password)
              .onChange((value: string) => {
                this.confirmPassword = value;
              })
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 10 })

            // 确认密码可见性切换
            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: this.confirmPasswordVisible })
                .onChange((isOn: boolean) => {
                  this.confirmPasswordVisible = isOn;
                })
                .size({ width: 24, height: 24 })

              Text('显示密码')
                .fontSize(14)
                .margin({ left: 5 })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .margin({ bottom: 50 })
          }
          .width('80%')

          // 注册按钮
          Button('注册', { type: ButtonType.Capsule })
            .onClick(() => {
              if (!this.username || !this.password || !this.confirmPassword) {
                console.error('请填写完整信息');
                return;
              }

              if (this.password !== this.confirmPassword) {
                console.error('两次输入的密码不一致');
                return;
              }

              // 模拟注册成功
              this.showSuccess = true;
            })
            .width(150)
            .height(50)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 注册成功提示
        Column() {
          Text('注册成功！')
            .fontSize(24)
            .margin({ bottom: 30 })

          Button('返回登录', { type: ButtonType.Capsule })
            .onClick(() => {
              router.back();
            })
            .width(150)
            .height(50)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
  }
}