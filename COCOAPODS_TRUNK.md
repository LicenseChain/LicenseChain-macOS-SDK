# CocoaPods trunk publish (LicenseChainmacOS)

Podspec file: `LicenseChainmacOS.podspec`  
Pod name: **LicenseChainmacOS**  
Version: **1.0.3**  
Git tag: **v1.0.3** (`a34dc18ce53417f836d3fcde8f3306d5cc27c918`)  
Source: `https://github.com/LicenseChain/LicenseChain-macOS-SDK.git`

CocoaPods trunk requires macOS. This environment is Linux — no trunk session was created or faked.

## Mac commands (exact)

```bash
# 1) One-time owner registration (confirm email from CocoaPods)
pod trunk register support@licensechain.app "LicenseChain LLC" --description="LicenseChain"

# 2) Clone / pull and lint
git clone https://github.com/LicenseChain/LicenseChain-macOS-SDK.git
cd LicenseChain-macOS-SDK
git checkout v1.0.3
pod spec lint LicenseChainmacOS.podspec --allow-warnings

# 3) Push
pod trunk push LicenseChainmacOS.podspec --allow-warnings

# 4) Verify
pod trunk info LicenseChainmacOS
pod search LicenseChainmacOS --simple
```

After trunk accepts the pod, consumers install with:

```ruby
pod 'LicenseChainmacOS', '~> 1.0.3'
```
