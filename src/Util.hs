module Util where

import           Control.Applicative
import           Control.Monad
import           Data.List
import           System.Directory
import           System.FilePath

stripEmptyLines :: String -> String
stripEmptyLines = unlines . reverse . dropWhile null . reverse . dropWhile null . lines

getFilesRecursive :: FilePath -> IO [FilePath]
getFilesRecursive baseDir = sort <$> go []
  where
    go :: FilePath -> IO [FilePath]
    go dir = do
      c <- map (dir </>) . filter (`notElem` [".", ".."]) <$> getDirectoryContents (baseDir </> dir)
      dirs <- filterM (doesDirectoryExist . (baseDir </>)) c >>= mapM go
      files <- filterM (doesFileExist . (baseDir </>)) c
      return (files ++ concat dirs)
