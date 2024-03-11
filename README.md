<!-- This can be changed -->
<p align="center">
    <a href="https://github.com/metis-os/hysp-pkgs">
        <img src="https://github.com/metis-os/hysp-pkgs/assets/58171889/0bdc0282-e018-4bdc-adfd-391392771ff4" width="400"></a>
    <br>
    <b><strong> <a href="https://github.com/Azathothas/Toolpacks">Statically Compiled Binaries</a> (Packages) for <a href="https://github.com/pwnwriter/hysp">Hysp</a>🌷</code></strong></b>
    <br>
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="500" />
</p>

---
<!-- DO NOT CHANGE -->
- #### 📦 Status
| 🧰 Architecture 🧰 | 📦 Total Packages 📦 | 📝 Detailed List 📝 | ⏬ Upstream Source ⏬ | 🇨🇭 WorkFlows 🇨🇭 |
|---------------------|-----------------------|----------------------|------------------------|-----------------|
|[`amd // x86_64`](https://github.com/metis-os/hysp-pkgs/tree/main/data/x86_64)|696| [x86_64.md](https://github.com/metis-os/hysp-pkgs/blob/main/data/x86_64.md) | [Azathothas/Toolpacks/x86_64](https://github.com/Azathothas/Toolpacks/tree/main/x86_64)|[![🛍️ (x86_64)⚙️ Daily 📦 Metadata 🗄️](https://github.com/metis-os/hysp-pkgs/actions/workflows/pkg_metafetcher_metaupdater_x86_64.yaml/badge.svg)](https://github.com/metis-os/hysp-pkgs/actions/workflows/pkg_metafetcher_metaupdater_x86_64.yaml)|
|[`aarch64 // arm64`](https://github.com/metis-os/hysp-pkgs/tree/main/data/aarch64_arm64)|435| [aarch64_arm64.md](https://github.com/metis-os/hysp-pkgs/blob/main/data/aarch64_arm64.md) | [Azathothas/Toolpacks/aarch64_arm64](https://github.com/Azathothas/Toolpacks/tree/main/aarch64_arm64)|[![🛍️ (aarch64_arm64) ⚙️ Daily 📦 Metadata 🗄️](https://github.com/metis-os/hysp-pkgs/actions/workflows/pkg_metafetcher_metaupdater_aarch64_arm64.yaml/badge.svg)](https://github.com/metis-os/hysp-pkgs/actions/workflows/pkg_metafetcher_metaupdater_aarch64_arm64.yaml)|

> - Raw **`metadata`** containing info for _all packages_ is available as [**`json`**](https://github.com/metis-os/hysp-pkgs/blob/main/data/metadata.json) & [**`toml`**](https://github.com/metis-os/hysp-pkgs/blob/main/data/metadata.toml)
> - [./pkgs](https://github.com/metis-os/hysp-pkgs/tree/main/pkgs) only contains a _couple of **test** packages_. Everything is hosted at : [Azathothas/Toolpacks](https://github.com/Azathothas/Toolpacks/tree/main/)
---
- #### 🚧 Security ⚙️
It is never a good idea to install random binaries from random sources. 
- Check these `HackerNews Discussions`
> - [A cautionary tale from the decline of SourceForge](https://news.ycombinator.com/item?id=31110206)
> - [Downloading PuTTY Safely Is Nearly Impossible (2014)](https://news.ycombinator.com/item?id=9577861)

Hysp offers the following sane-defaults:
- **`CheckSums`**
> Hysp requires either `blake3sum` / `sha256sum` in `$BINARY_SOURCE.toml` & always verifies them to ensure nothing has been tampered with.
- **`Transparency`**
> [Hysp](https://github.com/pwnwriter/hysp) is completely open-source. And so is the [default pkg-source](https://github.com/metis-os/hysp-pkgs). The upstream repos that it uses as source are also completely open-source. You are free to audit & scrutinize everything.
> ```bash
> !# PKG Metadata
> # Everything is automated via Github Actions & Scripts
> Repo --> https://github.com/metis-os/hysp-pkgs
> WorkFlows --> https://github.com/metis-os/hysp-pkgs/tree/main/.github/workflows
> Scripts --> https://github.com/metis-os/hysp-pkgs/tree/main/.github/scripts
> 
> !# Upstream Source
> # Everything is automated via Github Actions & Build Scripts
> Repo --> https://github.com/Azathothas/Toolpacks
> WorkFlows --> https://github.com/Azathothas/Toolpacks/tree/main/.github/workflows
> Build Scripts --> https://github.com/Azathothas/Toolpacks/tree/main/.github/scripts
> ```
- **`Self-Hostable`** : Hysp offers you to [completely self-host](https://github.com/pwnwriter/hysp#hosting-custom-repo-) the backend from where it fetches the binaries. If you do not trust the [default pkg-source](https://github.com/metis-os/hysp-pkgs), you can configure hysp to only use your source, hosted on your own servers.
> - A note on hysp allowing `http-only` sources
> > - Hysp will allow you to host your pkg-source repo anywhere & doesn't require http as it uses the checksums to verify the hashes.
> > - However, this decision to allow http-only sources is enabled for legacy compatibility reasons or in case you want hysp to use a HTTP_PROXY.
> > - **Never host both your data/*.toml & source binaries on http-only server.** This will expose you to `MITM` as an attacker could tamper with both the checksums & binaries. Hysp **will not be resposible for where you host your binaries or what kind of binaries you run**.
> > - You hold all responsibilities if you host the PKG Sources yourself.
> > - Check this hacker-news discussion: https://news.ycombinator.com/item?id=38457926#38473604
---
<!-- This can be changed -->
- #### 📟 [@pwnwriter](https://github.com/pwnwriter) 📟
> <a name="support"></a>
> #### Support 💌
>
> I am a student currently attending university. I like working for *Open Source* in my free time. If you find my tool or work beneficial, please consider supporting me via [*KO-FI*](https://ko-fi.com/pwnwriter) or [*ESEWA*](https://metislinux.org/docs/donate)* (***Nepal only***), Or by leaving a star ⭐ ; I'll appreciate your action :)
<a name="license"></a>
- #### License ㊙️
Everything is license under the [`MIT`](https://raw.githubusercontent.com/pwnwriter/hysp/main/LICENSE) except for the packages... 
They hold their own livess :oOO

<p align="center"><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" /></p>
<p align="center">Copyright &copy; 2023<a href="https://pwnwriter.xyz" target="_blank"> pwnwriter xyz </a> ☘️</p> 
