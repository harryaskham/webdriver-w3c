module Main where

import System.Environment (setEnv, getArgs, withArgs)
import System.Exit (exitFailure)
import System.Directory (getCurrentDirectory)
import Data.IORef

import Test.Tasty
import Test.Tasty.WebDriver

import Test.Tasty.WebDriver.Config.Test
import Web.Api.Http.Assert.Test
import Web.Api.Http.Effects.Test
import Web.Api.WebDriver.Monad.Test
import Web.Api.WebDriver.Types.Test


main :: IO ()
main = do

  putStrLn ""
  putStrLn "\x1b[1;34m      ___  __   __   __          ___  __           __   __     ___  ___  __  ___ \x1b[0;39;49m"
  putStrLn "\x1b[1;34m|  | |__  |__) |  \\ |__) | \\  / |__  |__) __ |  | '__\\ /  ` __  |  |__  /__`  |  \x1b[0;39;49m"
  putStrLn "\x1b[1;34m|/\\| |___ |__) |__/ |  \\ |  \\/  |___ |  \\    |/\\| .__/ \\__,     |  |___ .__/  |  \x1b[0;39;49m"
  putStrLn "\x1b[1;34m                                                                                 \x1b[0;39;49m"

  setEnv "TASTY_NUM_THREADS" "2" -- needed for live tests
  testPagePath <- fmap (\path -> path ++ "/test/page") getCurrentDirectory

  args <- getArgs
  withArgs (["--remote-ends","geckodriver: https://localhost:4444 https://localhost:4445 chromedriver: https://localhost:9515 https://localhost:9516"] ++ args) $
    defaultWebDriverMain $ testGroup "All Tests"
      [ Test.Tasty.WebDriver.Config.Test.tests
      , Web.Api.Http.Assert.Test.tests
      , Web.Api.WebDriver.Types.Test.tests
      , Web.Api.Http.Effects.Test.tests testPagePath
      , Web.Api.WebDriver.Monad.Test.tests ("file://" ++ testPagePath)
      ]
