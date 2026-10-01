class Videolib < Formula
  include Language::Python::Virtualenv

  desc "Telegram bot that downloads and delivers videos via yt-dlp"
  homepage "https://github.com/motiko/VideoLib"
  url "https://github.com/motiko/VideoLib/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000" # Updated automatically by CI on release
  license "MIT"

  depends_on "python@3.12"
  depends_on "yt-dlp"
  depends_on "ffmpeg"

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
    environment_variables VIDEOLIB_ENV_FILE: "#{Dir.home}/.config/videolib/.env"
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
