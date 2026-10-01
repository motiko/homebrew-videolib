class Videolib < Formula
  include Language::Python::Virtualenv

  desc "Telegram bot that downloads and delivers videos via yt-dlp"
  homepage "https://github.com/motiko/VideoLib"
  url "https://github.com/motiko/VideoLib/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3559783f84aca5eb22d3e734ba2c60e1d8659f77202a7da00bc5d612062ce0e2"
  license "MIT"

  depends_on "python@3.12"
  depends_on "yt-dlp"
  depends_on "ffmpeg"

  revision 2

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-telegram-bot" do
    url "https://files.pythonhosted.org/packages/ba/77/153517bb1ac1bba670c6fb1dbf09e1fd0730494b1705934e715391413a0d/python_telegram_bot-22.8.tar.gz"
    sha256 "f9d3847fcb23ee603477e442800b33bb4adf851a73e0619d2050be879decf1ef"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
    prefix.install ".env.example"
  end

  service do
    run [opt_bin/"videolib"]
    keep_alive crashed: true
    log_path var/"log/videolib/videolib.log"
    error_log_path var/"log/videolib/videolib.err.log"
    working_dir var/"lib/videolib"
    environment_variables VIDEOLIB_ENV_FILE: "#{Dir.home}/.config/videolib/.env", PATH: "#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  def post_install
    (var/"log/videolib").mkpath
    (var/"lib/videolib").mkpath
  end

  def caveats
    <<~EOS
      To configure VideoLib, create your config file:
        mkdir -p ~/.config/videolib
        cp #{opt_prefix}/.env.example ~/.config/videolib/.env
        # Edit ~/.config/videolib/.env with your TELEGRAM_BOT_TOKEN

      To start VideoLib as a background service:
        brew services start videolib

      To check service status:
        videolib --status
        brew services info videolib

      Logs are at:
        #{var}/log/videolib/
    EOS
  end

  test do
    assert_match "VideoLib", shell_output("#{bin}/videolib --help")
  end
end
