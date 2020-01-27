class GitLatexdiff < Formula
  desc "Wrapper around git and latexdiff"
  homepage "https://gitlab.com/git-latexdiff/git-latexdiff"
  url "https://gitlab.com/git-latexdiff/git-latexdiff.git",
    :tag => "1.4.0",
    :revision => "a9053f3208de194df1c019e059bfec4a290d31a5"

  depends_on "latexdiff"

  def install
    bin.install "git-latexdiff"
  end

  test do
    test_git_dir = testpath/"gldtest"
    test_pdf = testpath/"test.pdf"
    system "git", "clone", "https://gitlab.com/git-latexdiff/git-latexdiff.git", test_git_dir
    (test_git_dir/"tests/bib").cd do
      system "git", "latexdiff", "@~5", "--no-view", "-o", test_pdf
    end
    assert File.exist?(test_pdf)
  end
end
