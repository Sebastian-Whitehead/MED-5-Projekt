using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransitionManager : MonoBehaviour
{
    
    public FadeScreen fadeScreen;
    private AudioSource _soundSource;

    private void Start()
    {
        _soundSource = gameObject.GetComponent<AudioSource>();
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
