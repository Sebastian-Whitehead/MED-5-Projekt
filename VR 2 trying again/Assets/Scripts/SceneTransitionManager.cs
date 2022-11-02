using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransitionManager : MonoBehaviour
{
    
    public FadeScreen fadeScreen;       // Fading plane attached to the players head
    private AudioSource _soundSource;   // Audio Source on this game objet

    private void Start()
    {
        _soundSource = gameObject.GetComponent<AudioSource>();
        _soundSource.Play();
    }

    public void GoToScene(string sceneName)
    {
        StartCoroutine(GoToSceneRoutine(sceneName));
    }
    
    IEnumerator GoToSceneRoutine(string sceneName)
    {
        fadeScreen.FadeOut();
        yield return new WaitForSeconds(fadeScreen.fadeDuration);
        
        //Launch the new scene
        SceneManager.LoadScene(sceneName);
        _soundSource.Play();
    }
}
