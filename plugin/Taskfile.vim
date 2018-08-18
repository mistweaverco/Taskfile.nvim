if exists("g:loaded_Taskfile")
        finish
endif
let g:loaded_Taskfile = 1

let s:PluginName = "Taskfile.nvim"
let s:isVerbose = 0

function! Taskfile#Verbose(enable)
        if a:enable == 1
                let s:isVerbose = 1
        else
                let s:isVerbose = 0
        endif
endfunction

function! Taskfile#Run(...)
        let task = get(a:, 1, "")
        let cmd = "./Taskfile " . task
        call s:ExecExternalCommand(cmd)
endfunction

function! Taskfile#List()
        let cfg = s:GetAllTasks()
        let cmd = s.GetTaskfileFilename()
        call s:ExecExternalCommand(cmd)
endfunction

function! s:OnJobEventHandler(job_id, data, event) dict
        if a:event == 'stdout'
                let str = self.shell.' stdout: '.join(a:data)
        elseif a:event == 'stderr'
                let str = self.shell.' stderr: '.join(a:data)
        else
                let str = self.shell.' finished'
        endif
        echom str
endfunction

let s:jobEventCallbacks = {
        \ 'on_stdout': function('s:OnJobEventHandler'),
        \ 'on_stderr': function('s:OnJobEventHandler'),
        \ 'on_exit': function('s:OnJobEventHandler')
\ }

function! s:GetAllTasks()
        let filepath = getcwd() . "/" . s:GetTaskfileFilename()
        let str = s:ReadfileAsString(filepath)
        return str
endfunction

function! s:GetTaskfileFilename()
        return "Taskfile"
endfunction

function! s:ExecExternalCommand(command)
        if has("nvim") == 1
                if s:isVerbose == 0
                        call jobstart(["bash", "-c", a:command])
                else
                        new | call termopen(["bash", "-c", a:command], extend({"shell": s:PluginName}, s:jobEventCallbacks))
                endif
        elseif v:version >= 800
                if s:isVerbose == 0
                        call job_start("bash -c " . a:command)
                else
                        new termopen(["bash", "-c", a:command], extend({"shell": s:PluginName}, s:jobEventCallbacks))
                endif
        else
                if s:isVerbose == 1
                        execute "!" . a:command
                else
                        silent execute "!" . a:command
                endif
        endif
endfunction

function! s:GetBasename(...)
        let buffername = bufname("%")
        let filepath = get(a:, 1, buffername)
        return fnamemodify(filepath, ":t")
endfunction

function! s:ReadfileAsString(filepath)
        return readfile(a:filepath)
endfunction

function! s:GetCurrentFile()
        return expand("%")
endfunction

command! -nargs=1 Taskfile call Taskfile#Run(<f-args>)

